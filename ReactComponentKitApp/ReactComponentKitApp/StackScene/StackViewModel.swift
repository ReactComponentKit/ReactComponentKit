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

struct StackViewState: State {
    var color: UIColor = .red
    var text: String = ""
    var error: (Error, Action)? = nil
}

class StackViewModel: RootViewModelType<StackViewState> {
    override init() {
        super.init()
        store.set(
            initailState: StackViewState(),
            reducers: [
                StateKeyPath(\StackViewState.color): colorReducer,
                StateKeyPath(\StackViewState.text): textReducer
            ])
    }
    
    override func on(newState: StackViewState) {
        // 하위 커포넌트에게 새로운 상태를 전달함
        eventBus.post(event: .on(state: newState))
    }
}
