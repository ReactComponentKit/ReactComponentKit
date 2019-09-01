//
//  Token.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019/09/01.
//  Copyright © 2019 Burt.K. All rights reserved.
//

import Foundation

public struct Token: Equatable {
    private let token: String
    public init() {
        self.init(value: UUID().uuidString)
    }
    private init(value: String) {
        token = value
    }
    public static let empty = Token(value: "")
    internal func toString() -> String {
        return token
    }
}
