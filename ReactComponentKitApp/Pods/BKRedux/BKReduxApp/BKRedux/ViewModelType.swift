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

public struct VoidAction: Action {
    public init() {
    }
}

open class ViewModelType<S: State> {
    // rx port
    public let rx_action = BehaviorRelay<Action>(value: VoidAction())
    public let rx_state = BehaviorRelay<S?>(value: nil)
    
    public let store = Store<S>()
    public let disposeBag = DisposeBag()
    
    public init() {
        setupRxStream()
    }
    
    private func setupRxStream() {
        rx_action
            .filter { type(of: $0) != VoidAction.self }
            .map(beforeDispatch)
            .filter { type(of: $0) != VoidAction.self }
            .flatMap(store.dispatch)
            .observeOn(MainScheduler.asyncInstance)
            .map({ (state: State?) -> S? in
                return state as? S
            })
            .bind(to: rx_state)
            .disposed(by: disposeBag)
        
        rx_state
            .subscribe(onNext: { [weak self] (newState: S?) in
                guard let newState = newState else { return }
                if let (error, action) = newState.error {
                    self?.on(error: error, action: action, onState: newState)
                } else {
                    self?.on(newState: newState)
                }
            })
            .disposed(by: disposeBag)
    }
    
    open func beforeDispatch(action: Action) -> Action {
        return action
    }
    
    open func on(newState: S) {
        
    }
    
    open func on(error: Error, action: Action, onState: S) {
        
    }
}

