//
//  ViewModelType.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 29..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

open class ViewModelType<S: State> {
    // rx port
    private let rx_action = BehaviorRelay<Action>(value: VoidAction())
    private let rx_state = BehaviorRelay<S?>(value: nil)
    
    public let store = Store<S>()
    public let disposeBag = DisposeBag()
    private var nextAction: Action? = nil
    private var applyNewState: Bool = false
    private var actionQueue = Queue<(Action, Bool)>()
    
    public init() {
        setupRxStream()
    }
    
    /// If you use ViewModel as a namespce for middleware, reducer and postware,
    /// You should call this method in ViewController's deinit
    /// Because the array for middleware, reducer and postware has strong reference to
    /// ViewModel's instance method(ex: middleware, reducer, postware)
    public func deinitialize() {
        store.deinitialize()
    }
    
    private func setupRxStream() {
        rx_action
            .filter { type(of: $0) != VoidAction.self }
            .map({ [weak self] (action) in
                return self?.beforeDispatch(action: action) ?? VoidAction()
            })
            .filter { type(of: $0) != VoidAction.self }
            .flatMap { [unowned self] (action)  in
                return self.store.dispatch(action: action)
            }
            .observeOn(MainScheduler.asyncInstance)
            .map({ (state: State?) -> S? in
                return state as? S
            })
            .subscribe(onNext: { [weak self] (state: S?) in
                self?.rx_state.accept(state)
            })
            .disposed(by: disposeBag)
        
        rx_state
            .subscribe(onNext: { [weak self] (newState: S?) in
                guard let newState = newState else { return }
                if let (error, action) = newState.error {
                    self?.on(error: error, action: action)
                } else {
                    if let (nextAction, apply) = self?.actionQueue.dequeue() {
                        if apply == true {
                            self?.on(newState: newState)
                        }
                        self?.rx_action.accept(nextAction)
                    } else {
                        self?.on(newState: newState)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    public func dispatch(action: Action) {
        if actionQueue.isEmpty {
            rx_action.accept(action)
        } else {
            actionQueue.enqueue(item: (action, true))
        }
    }
    
    public func nextDispatch(action: Action, applyNewState: Bool = false) {
        actionQueue.enqueue(item: (action, applyNewState))
    }
    
    open func beforeDispatch(action: Action) -> Action {
        return action
    }
    
    open func on(newState: S) {
        
    }
    
    open func on(error: Error, action: Action) {
        
    }
}

