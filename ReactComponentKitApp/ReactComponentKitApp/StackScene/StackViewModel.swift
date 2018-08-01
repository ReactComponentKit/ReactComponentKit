//
//  StackViewModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 1..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKRedux
import BKEventBus

class StackViewModel: RootViewModelType {
    override init() {
        super.init()
        store.set(state: [
            "color": UIColor.red
        ], reducers: [
            "color": colorReducer
        ])
    }
    
    override func on(newState: [String : State]?) {
        eventBus.post(event: .on(state: newState?["color"]))
    }
}
