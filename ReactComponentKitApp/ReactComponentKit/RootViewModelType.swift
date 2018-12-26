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

open class RootViewModelType<S: State>: ViewModelType<S> {
    public let token: Token
    public let eventBus: EventBus<ComponentNewStateEvent>
    private let dispatchEventBus: EventBus<ComponentDispatchEvent>
    
    public override init() {
        self.token = Token()
        self.eventBus = EventBus(token: self.token)
        self.dispatchEventBus = EventBus(token: self.token)
        super.init()
        
        dispatchEventBus.on { [weak self] (event) in
            switch event {
            case let .dispatch(action):
                self?.dispatch(action: action)
            }
        }
    }
}
