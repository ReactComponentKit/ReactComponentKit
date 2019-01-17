//
//  ComponentUIViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 4..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import BKEventBus
import BKRedux

open class UIViewControllerComponent: UIViewController, ReactComponent {
    
    public var newStateEventBus: EventBus<ComponentNewStateEvent>? = nil
    public var dispatchEventBus: EventBus<ComponentDispatchEvent>
    
    public var token: Token
    
    public required init(token: Token, receiveState: Bool = true) {
        self.token = token
        self.dispatchEventBus = EventBus(token: token)
        if receiveState == true {
            self.newStateEventBus = EventBus(token: token)
        }
        super.init(nibName: nil, bundle: nil)
        newStateEventBus?.on { [weak self] (event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .on(state):
                strongSelf.applyNew(state: state)
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyNew(state: State) {
        on(state: state)
    }
    
    open func on(state: State) {
        
    }
    
    public func dispatch(action: Action) {
        dispatchEventBus.post(event: .dispatch(action: action))
    }
}
