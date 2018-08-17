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
            "color": UIColor.red,
            "text": ""
        ], reducers: [
            "color": colorReducer,
            "text": textReducer
        ])
    }
    
    override func on(newState: [String : State]?) {
        // 하위 커포넌트에게 새로운 상태를 전달함
        eventBus.post(event: .on(state: newState))
    }
}
