//
//  RCK.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019/09/01.
//  Copyright © 2019 Burt.K. All rights reserved.
//

import Foundation

internal class RCK {
    
    private var map: [String: Any] = [:]
    
    internal static let instance = RCK()
    
    private init() {}
    
    
    internal func registerViewModel<S: State>(token: Token, viewModel: RCKViewModel<S>) {
        map[token.toString()] = viewModel
    }
    
    internal func unregisterViewModel(token: Token) {
        map.removeValue(forKey: token.toString())
    }
    
    internal func viewModel(token: Token) -> RCKViewModelType? {
        return map[token.toString()] as? RCKViewModelType
    }
}
