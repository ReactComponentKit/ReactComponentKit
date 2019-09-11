//
//  DispatchExtension.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019/09/08.
//  Copyright © 2019 Burt.K. All rights reserved.
//

import Foundation

extension ReactComponent {
    public func dispatch(action: Action) {
        let viewModel = RCK.instance.viewModel(token: self.token)
        viewModel?.dispatch(action: action)
    }
}
