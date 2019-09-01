//
//  RCKError.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019/09/01.
//  Copyright © 2019 Burt.K. All rights reserved.
//

import Foundation

public struct RCKError {
    public let error: Error
    public let action: Action
    public init(error: Error, action: Action) {
        self.error = error
        self.action = action
    }
}
