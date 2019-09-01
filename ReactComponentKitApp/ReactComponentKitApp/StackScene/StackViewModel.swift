//
//  StackViewModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 1..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import UIKit

struct StackViewState: State, MessageViewComponentState, RedViewComponentState {
    var color: UIColor = .red
    var text: String = ""
    var error: RCKError? = nil
}

class StackViewModel: RCKViewModel<StackViewState> {
    
    override func setupStore() {
        initStore { (store) in
            store.initial(state: StackViewState())
//            store.set(
//                initialState: StackViewState(),
//                reducers: [
//                    colorReducer,
//                    textReducer
//                ])
        }
    }
    
    override func on(newState: StackViewState) {
        // 하위 커포넌트에게 새로운 상태를 전달함
        //propagate(state: newState)
    }
}
