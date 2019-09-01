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

open class RCKViewModel<S: State> {
    public let token = Token()
    
    // rx port
    private let rx_action = BehaviorRelay<Action>(value: VoidAction())
    private let rx_state = BehaviorRelay<S?>(value: nil)
    private let store = Store<S>()
    private let disposeBag = DisposeBag()
    private var subscribers: [StateSubscriber] = []
    private let writeLock = DispatchSemaphore(value: 1) // Allow only one thread.
    private let readLock = DispatchSemaphore(value: 1) // Allow only one thread.
    
    public init() {
        setupRxStream()
        setupStore()
    }
    
    /// If you use ViewModel as a namespce for middleware, reducer and postware,
    /// You should call this method in ViewController's deinit
    /// Because the array for middleware, reducer and postware has strong reference to
    /// ViewModel's instance method(ex: middleware, reducer, postware)
    public func deinitialize() {
        subscribers.removeAll()
        subscribers = []
        store.deinitialize()
        RCK.instance.unregisterViewModel(token: token)
    }
    
    private func setupRxStream() {
        rx_action
            .filter { type(of: $0) != VoidAction.self }
            .flatMap { [unowned self] (action)  in
                return self.store.dispatch(action: action)
            }
            .observeOn(MainScheduler.asyncInstance)
            .do(afterNext: { _ in
                
            })
            .map({ (state: State?) -> S? in
                return state as? S
            })
            .subscribe(onNext: { [weak self] (newState: S?) in
                guard let newState = newState else { return }
                if let error = newState.error {
                    self?.on(error: error)
                } else {
                    self?.dispatchStateToSubscribers(state: newState)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func dispatchStateToSubscribers(state: S) {
        on(newState: state)
        subscribers.forEach { (subscriber) in
            subscriber.on(state: state)
        }
    }
    
    public func registerSubscriber(subscriber: StateSubscriber) {
        subscribers.append(subscriber)
    }
    
    public final func dispatch<A: Action>(action: A) {
        rx_action.accept(action)
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
    
 
    func setState(block: (S) -> S) -> S {
        writeLock.wait()
        defer {
            writeLock.signal()
        }
        
        let newState = block(self.store.state)
        DispatchQueue.main.sync {
            on(newState: newState)
        }
        return newState
    }
    
    func withState<R>(block: (S) -> R) -> R {
        readLock.wait()
        defer {
            readLock.signal()
        }
        return block(self.store.state)
    }
    
    func asyncReducer<A: Action>(state: S, action: A, block: @escaping (A) -> Observable<S>) -> S {
        asyncFlow(block: block)(state, action)
        return state
    }
    
    @discardableResult
    func asyncFlow<A: Action>(block: @escaping (A) -> Observable<S>) -> Reducer<S, A> {
        return { [weak self] (state: S, action: A) in
            guard let strongSelf = self else { return state }
            block(action)
                .subscribeOn(Q.serialQ)
                .observeOn(MainScheduler.asyncInstance)
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
            return state
        }
    }
}
