//
//  RedViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 31..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit

protocol RedViewComponentState {
    var color: UIColor { get }
}

class RedViewComponent: UIViewControllerComponent {
    
    static func viewController(token: Token) -> UIViewController {
        return RedViewComponent(token: token)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dispatch(action: RandomColorAction())
    }
    
    override func on(state: State) {
        guard let componentState = state as? RedViewComponentState else { return }
        if view.backgroundColor != componentState.color {
            view.backgroundColor = componentState.color
        }
    }
}
