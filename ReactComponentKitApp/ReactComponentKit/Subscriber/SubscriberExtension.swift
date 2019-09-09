//
//  SubscriberExtension.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019/09/08.
//  Copyright © 2019 Burt.K. All rights reserved.
//

import Foundation

extension ReactComponent {
    public func subscribeState() {
        let viewModel = RCK.instance.viewModel(token: self.token)
        viewModel?.registerSubscriber(subscriber: self)
    }
}

extension StateSubscriber {
    public func subscribeState(token: Token) {
        guard token != Token.empty else { return }
        let viewModel = RCK.instance.viewModel(token: token)
        viewModel?.registerSubscriber(subscriber: self)
    }
}
