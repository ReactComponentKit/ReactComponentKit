//
//  UIViewController+Child.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 31..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    @discardableResult
    public func add(viewController: UIViewController) -> UIViewController {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        return viewController
    }
    
    @discardableResult
    public func add(viewController: UIViewController, belowSubview: UIView) -> UIViewController {
        addChild(viewController)
        view.insertSubview(viewController.view, belowSubview: belowSubview)
        viewController.didMove(toParent: self)
        return viewController
    }
    
    @discardableResult
    public func add(viewController: UIViewController, aboveSubview: UIView) -> UIViewController {
        addChild(viewController)
        view.insertSubview(viewController.view, aboveSubview: aboveSubview)
        viewController.didMove(toParent: self)
        return viewController
    }
        
    public func removeFromSuperViewController() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
