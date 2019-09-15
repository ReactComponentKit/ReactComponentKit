//
//  RCKViewModel.swift
//  BKReduxApp
//
//  Created by burt on 2019/09/01.
//  Copyright © 2019 Burt.K. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxBlocking

internal protocol RCKViewModelType {
    func registerSubscriber(subscriber: StateSubscriber)
    func dispatch(action: Action)
    func nextDispatch(action: Action)
}

open class RCKViewModel<S: State>: RCKViewModelType {
    public let token = Token()
    
    // rx port
    private let rx_action = BehaviorRelay<Action>(value:
        VoidAction()
    )
    private let store = Store<S>()
    private let disposeBag = DisposeBag()
    private var actionQueue: Queue<Action> = Queue()
    private var subscribers: [StateSubscriber] = []
    private let writeLock = DispatchSemaphore(value: 1) // Allow only one thread.
    private let readLock = DispatchSemaphore(value: 1) // Allow only one thread.
    private let dispatchLock = DispatchSemaphore(value: 1) // Allow only one thread.
    
    public init() {
        setupRxStream()
        setupStore()
    }
    
    /// If you use ViewModel as a namespce for middleware, reducer and postware,
    /// You should call this method in ViewController's deinit
    /// Because the array for middleware, reducer and postware has strong reference to
    /// ViewModel's instance method(ex: middleware, reducer, postware)
    public func deinitialize() {
        RCK.instance.unregisterViewModel(token: token)
        actionQueue.clear()
        subscribers.removeAll()
        subscribers = []
        store.deinitialize()
        
    }
    
    private func setupRxStream() {
        rx_action
            .filter { type(of: $0) != VoidAction.self }
            .observeOn(MainScheduler.instance)
            .filter { [unowned self] (action) in
                let returnedAction = self.store.startFlow(action: action)
                return type(of: returnedAction) != VoidAction.self
            }
            .observeOn(Q.concurrentQ)
            .flatMap { [unowned self] (action)  in
                return self.store.dispatch(action: action)
            }
            .observeOn(MainScheduler.instance)
            .do(afterNext: { [unowned self] _ in
                self.store.doAfterEffects()
                if (self.actionQueue.isNotEmpty) {
                    if let nextAction = self.actionQueue.dequeue() {
                        self.rx_action.accept(nextAction)
                    }
                }
            })
            .subscribe(onNext: { [weak self] (newState: S) in
                if let error = newState.error {
                    self?.on(error: error)
                } else {
                    self?.dispatchStateToSubscribers(state: newState)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func dispatchStateToSubscribers(state: S) {
        dispatchLock.wait()
        defer {
            dispatchLock.signal()
        }
        
        on(newState: state)
        subscribers.forEach { (subscriber) in
            subscriber.on(state: state)
        }
    }
    
    public final func registerSubscriber(subscriber: StateSubscriber) {
        subscribers.append(subscriber)
    }
    
    public final func dispatch(action: Action) {
        rx_action.accept(action)
    }

    public final func nextDispatch(action: Action) {
        if (actionQueue.isEmpty) {
            rx_action.accept(action)
        } else {
            actionQueue.enqueue(item: action)
        }
    }
            
    open func on(newState: S) {
    }
    
    open func on(error: RCKError) {
    }
    
    open func setupStore() {
    }
    
    public final func initStore(block: (Store<S>) -> Swift.Void) {
        RCK.instance.registerViewModel(token: token, viewModel: self)
        block(self.store)
    }
    
    @discardableResult
    public final func setState(block: (S) -> S) -> S {
        writeLock.wait()
        defer {
            writeLock.signal()
        }
        
        let newState = block(self.store.state)
        if Thread.isMainThread {
            self.store.state = newState
            dispatchStateToSubscribers(state: newState)
        } else {
            DispatchQueue.main.sync { [weak self] in
                self?.store.state = newState
                dispatchStateToSubscribers(state: newState)
            }
        }
        return newState
    }
    
    @discardableResult
    public final func withState<R>(block: (S) -> R) -> R {
        readLock.wait()
        defer {
            readLock.signal()
        }
        return block(self.store.state)
    }
    
    public final func awaitFlow<A: Action>(_ asyncReducer: @escaping AsyncReducer<S, A>) -> Reducer<S, A> {
        return { (state: S, action: A) -> S? in
            do {
                return try asyncReducer(action)
                .subscribeOn(Q.concurrentQ)
                .toBlocking()
                .last()
            } catch {
                return state.copy { $0.error = RCKError(error: error, action: action) }
            }
        }
    }
    
    public final func asyncFlow<A: Action>(_ asyncReducer: @escaping AsyncReducer<S, A>) -> Reducer<S, A> {
        return { [weak self] ( state: S, action: A) -> S? in
            guard let strongSelf = self else { return nil }
            asyncReducer(action)
                .subscribeOn(Q.concurrentQ)
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: { newState in
                        guard let strongSelf = self else { return }
                        strongSelf.writeLock.wait()
                        strongSelf.store.state = newState
                        strongSelf.dispatchStateToSubscribers(state: newState)
                        strongSelf.writeLock.signal()
                    },
                    onError: { (error) in
                        strongSelf.on(error: RCKError(error: error, action: action))
                    }
                )
                .disposed(by: strongSelf.disposeBag)
            return nil
        }
    }
}
