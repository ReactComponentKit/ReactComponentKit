//
//  Component.swift
//  ReactComponentKit
//
//  Created by burt on 2018. 7. 21..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKEventBus
import UIKit

class Component<S: StateType>: UIView {
    var state: S? = nil
    private let eventBus = EventBus<Store.Event>()
    
    func configure(state: S) {
        self.state = state
    }
    
    func render(state: S) {
        
    }
    
    func set(newState: S) {
        guard let state = state else { return }
        //if state != newState {
            render(state: newState)
            self.state = newState
        //}
    }
    
    func layout(withinContainer container: UIView) {
        
    }
    
    func dispatch(action: ActionType) {
        guard let state = state else { return }
        eventBus.post(event: .dispatch(state: state, action: action))
    }
    
    
}

extension UIView {
    func add<S: StateType>(component: Component<S>) {
        addSubview(component)
        component.layout(withinContainer: self)
    }
}

extension Component {
    func add(component: Component) {
        addSubview(component)
        component.layout(withinContainer: self)
    }
}
