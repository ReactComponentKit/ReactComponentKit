//
//  StackViewModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 1..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import UIKit

struct StackViewState: State, MessageViewComponentState {
    var text: String = ""
    var error: RCKError? = nil
}

class StackViewModel: RCKViewModel<StackViewState> {
    
    override func setupStore() {
        initStore { (store) in
            store.initial(state: StackViewState())
            store.flow(action: TextAction.self)
                .flow(textReducer)
        }
    }    
}
