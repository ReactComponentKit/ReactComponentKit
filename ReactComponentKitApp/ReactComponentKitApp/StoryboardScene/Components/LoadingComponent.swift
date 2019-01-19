//
//  LoadingComponent.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019. 1. 19..
//  Copyright © 2019년 Burt.K. All rights reserved.
//

import UIKit

class LoadingComponent: UIViewControllerComponent {
    override class func viewControllerComponent() -> UIViewControllerComponent {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return viewControllerComponent(identifier: "LoadingComponent", storyboard: storyboard)
    }
}
