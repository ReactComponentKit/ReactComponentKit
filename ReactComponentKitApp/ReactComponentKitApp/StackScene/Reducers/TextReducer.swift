//
//  TextReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 2..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import RxSwift

func textReducer(state: State, action: Action) -> Observable<State> {
    guard var mutableState = state as? StackViewState else { return .just(state) }
    
    if let act = action as? TextAction {
        mutableState.text += " \(act.payload)"
    }
    
    return .just(mutableState)
}
