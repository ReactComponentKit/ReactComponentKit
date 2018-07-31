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
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        return viewController
    }
        
    public func removeFromSuperViewController() {
        guard parent != nil else { return }
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
