//
//  ColorReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 28..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import RxSwift
import UIKit

func colorReducer(state: CounterSceneState, action: RandomColorAction) -> CounterSceneState {
    var mutableState = state
    mutableState.color = action.payload
    return mutableState
}
