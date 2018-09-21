//
//  State.swift
//  BKReduxApp
//
//  Created by burt on 2018. 9. 21..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

public protocol State {
    var error: (Error, Action)? { get set }
}

public typealias StateValue = Any
