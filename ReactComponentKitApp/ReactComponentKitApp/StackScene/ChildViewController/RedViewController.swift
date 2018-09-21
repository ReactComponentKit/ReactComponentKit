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
        dispatch(action: RandomColorAction())
    }
    
    override func on(state: State) {
        guard let stackViewState = state as? StackViewState else { return }
        view.backgroundColor = stackViewState.color
    }
}
