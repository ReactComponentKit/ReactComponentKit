//
//  Component.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 31..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import UIKit
import BKEventBus
import BKRedux

public enum ComponentNewStateEvent: EventType {
    case on(state: State)
}

public enum ComponentDispatchEvent: EventType {
    case dispatch(action: Action)
}

// Component that can listen to events & dispatch actions
public protocol ReactComponent {
    var token: Token { get set }
    // ReactComponent only has newStateEventBus if it is want to receive the new state.
    // If ReactComponent is in UITableView's cell or UICollectionView's cell,
    // it doesn't receive new state via newStateEventBus for the performance reason.
    // If every cell component receive new state event bus, there are many copying state.
    var newStateEventBus: EventBus<ComponentNewStateEvent>? { get }
    // ReactComponent always has dispatchEventBus for dispatching actions.
    var dispatchEventBus: EventBus<ComponentDispatchEvent> { get }
    init(token: Token, canOnlyDispatchAction: Bool)
}

// Component's content size provider
public protocol ContentSizeProvider {
    var contentSize: CGSize { get }
}
