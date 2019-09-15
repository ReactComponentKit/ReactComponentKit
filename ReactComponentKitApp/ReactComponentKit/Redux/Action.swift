//
//  Action.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

public protocol Action {
    static var name: String { get }
}

extension Action {
    public static var name: String {
        return "\(type(of: self))"
    }
}

public struct VoidAction: Action {
    public init() {
    }
}
