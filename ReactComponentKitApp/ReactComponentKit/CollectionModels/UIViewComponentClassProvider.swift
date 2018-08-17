//
//  UIViewComponentClassProvider.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

public protocol UIViewComponentClassProvider {
    var componentClass: UIViewComponent.Type { get }
}
