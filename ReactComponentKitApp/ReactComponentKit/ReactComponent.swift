//
//  Component.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 31..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import UIKit

// Component that can listen to events & dispatch actions
public protocol ReactComponent {
    var token: Token { get set }
    init(token: Token)
}

// Component's content size provider
public protocol ContentSizeProvider {
    var contentSize: CGSize { get }
}
