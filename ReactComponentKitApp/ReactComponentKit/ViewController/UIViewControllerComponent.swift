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

public class UIViewControllerComponent: UIViewController, Component {
    
    public lazy var eventBus: EventBus<ComponentEvent> = {
        return EventBus(token: self.token)
    }()
    
    public var token: Token
    public required init(token: Token) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
        
        eventBus.on { [weak self] (event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .on(state):
                strongSelf.applyNew(state: state)
            default:
                break
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyNew(state: [String:State]?) {
        on(state: state)
    }
    
    func on(state: [String:State]?) {
        
    }
}
