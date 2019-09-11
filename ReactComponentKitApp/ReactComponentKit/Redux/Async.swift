//
//  Async.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019/09/01.
//  Copyright © 2019 Burt.K. All rights reserved.
//

import Foundation

public enum Async<T> {
    case uninitialized
    case loading
    case success(value: T)
    case failed(error: RCKError)
}
