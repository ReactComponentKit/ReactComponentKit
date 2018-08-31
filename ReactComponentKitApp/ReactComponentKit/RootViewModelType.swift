//
//  RootComponentViewModelType.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 1..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKRedux
import BKEventBus
import RxSwift

open class RootViewModelType: ViewModelType {
    public let token: Token
    public let eventBus: EventBus<ComponentNewStateEvent>
    private let dispatchEventBus: EventBus<ComponentDispatchEvent>
    
    public override init() {
        self.token = Token()
        self.eventBus = EventBus(token: self.token)
        self.dispatchEventBus = EventBus(token: self.token)
        super.init()
        
        dispatchEventBus.on { [weak self] (event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .dispatch(action):
                strongSelf.beforeDispatch(action: action)
                Observable.just(action).bind(to: strongSelf.rx_action).disposed(by: strongSelf.disposeBag)
            }
        }
    }
    
    // It is called when before dispatching actions.
    // You can do some additional work before dispatching actions.
    open func beforeDispatch(action: Action) {
        
    }
}
