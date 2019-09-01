//
//  CountReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

func increaseCount(state: CounterSceneState, action: Action) -> CounterSceneState {
    guard let act = action as? IncreaseAction else { return state }
    var mutableState = state
    mutableState.count += act.payload
    return mutableState
}


func decreaseCount(state: CounterSceneState, action: Action) -> CounterSceneState {
    guard let act = action as? DecreaseAction else { return state }
    var mutableState = state
    mutableState.count += act.payload
    return mutableState
}
