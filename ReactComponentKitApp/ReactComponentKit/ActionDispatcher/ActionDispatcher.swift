//
//  ActionDispatcher.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019/09/08.
//  Copyright © 2019 Burt.K. All rights reserved.
//

import Foundation

public class ActionDispatcher {
    private let token: Token
    public init(token: Token) {
        self.token = token
    }
    
    public func dispatch(action: Action) {
        let viewModel = RCK.instance.viewModel(token: token)
        viewModel?.dispatch(action: action)
    }
}
