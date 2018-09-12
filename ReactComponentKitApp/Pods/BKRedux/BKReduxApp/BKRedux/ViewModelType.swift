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

open class ViewModelType {
    // rx port
    public let rx_action = BehaviorRelay<Action>(value: VoidAction())
    public let rx_state = BehaviorRelay<[String:State]?>(value: nil)
    
    public let store = Store()
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
            .bind(to: rx_state)
            .disposed(by: disposeBag)
        
        rx_state
            .subscribe(onNext: { [weak self] (newState) in
                if let (error, action) = newState?["error"] as? (Error, Action) {
                    self?.on(error: error, action: action)
                } else {
                    self?.on(newState: newState)
                }
            })
            .disposed(by: disposeBag)
    }
    
    open func beforeDispatch(action: Action) -> Action {
        return action
    }
    
    open func on(newState: [String:State]?) {
        
    }
    
    open func on(error: Error, action: Action) {
        
    }
}

