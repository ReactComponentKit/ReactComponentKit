//
//  CountReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux
import RxSwift

func countReducer(state: State, action: Action) -> Observable<State> {
    guard var mutableState = state as? CounterSceneState else { return .just(state) }
    
    switch action {
    case let act as IncreaseAction:
        mutableState.count += act.payload
    case let act as DecreaseAction:
        mutableState.count += act.payload
    default:
        break
    }
    
    return .just(mutableState)
}
