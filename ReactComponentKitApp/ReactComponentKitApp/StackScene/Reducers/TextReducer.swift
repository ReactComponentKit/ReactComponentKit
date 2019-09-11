//
//  TextReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 2..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import RxSwift

func textReducer(state: StackViewState, action: TextAction) -> StackViewState {
    var mutableState = state
    mutableState.text += " \(action.payload)"
    return mutableState
}
