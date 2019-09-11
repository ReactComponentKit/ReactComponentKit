//
//  CountReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

func increaseCount(state: CounterSceneState, action: IncreaseAction) -> CounterSceneState {
    var mutableState = state
    mutableState.count += action.payload
    return mutableState
}


func decreaseCount(state: CounterSceneState, action: DecreaseAction) -> CounterSceneState {
    var mutableState = state
    mutableState.count += action.payload
    return mutableState
}
