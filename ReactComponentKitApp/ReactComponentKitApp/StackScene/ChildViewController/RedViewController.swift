//
//  RedViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 31..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import BKEventBus
import BKRedux

class RedViewController: UIViewControllerComponent {
    
    static func viewController(token: Token) -> UIViewController {
        return RedViewController(token: token)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        eventBus.post(event: .dispatch(action: RandomColorAction()))
    }
    
    override func on(state: [String : State]?) {
        if let newColor = state?["color"] as? UIColor {
            view.backgroundColor = newColor
        }
    }
}
