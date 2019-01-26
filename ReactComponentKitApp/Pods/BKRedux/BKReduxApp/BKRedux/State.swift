//
//  State.swift
//  BKReduxApp
//
//  Created by burt on 2018. 9. 21..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

public protocol State {
    init()
    var error: (Error, Action)? { get set }
}
