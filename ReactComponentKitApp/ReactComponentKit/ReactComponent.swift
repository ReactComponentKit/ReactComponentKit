//
//  Component.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 31..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import UIKit

public protocol StateSubscriber {
    func on(state: State)
}

// Component that can listen to events & dispatch actions
public protocol ReactComponent: StateSubscriber {
    var token: Token { get set }
    init(token: Token)
}

// Component's content size provider
public protocol ContentSizeProvider {
    var contentSize: CGSize { get }
}

extension ReactComponent {
    func on(state: State) {
        // ignore
    }
}
