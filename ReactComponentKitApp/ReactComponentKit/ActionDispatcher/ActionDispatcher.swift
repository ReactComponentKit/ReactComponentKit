//
//  ActionDispatcher.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019. 2. 5..
//  Copyright © 2019년 Burt.K. All rights reserved.
//

import Foundation
import BKEventBus
import BKRedux

/// Dispatch actions where to has same token
/// It is used among component which has root view models.
public class ActionDispatcher {
    private let  token: Token
    private let dispatchEventBus: EventBus<ComponentDispatchEvent>
    public init(token: Token) {
        self.token = token
        dispatchEventBus = EventBus(token: token)
    }
    
    /// dispatch action where to has same token
    public func dispatch(action: Action) {
        dispatchEventBus.post(event: .dispatch(action: action))
    }
}

