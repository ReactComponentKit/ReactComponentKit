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
    var error: RCKError? { get set }
}

extension State {
    public func copy(_ mutate: (_ mutableData: inout Self) -> Void) -> Self {
        var mutableData = self
        mutate(&mutableData)
        return mutableData
    }
}
