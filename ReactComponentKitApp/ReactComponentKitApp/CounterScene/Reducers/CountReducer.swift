//
//  CountReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux
import RxSwift

func countReducer<S>(name: StateKeyPath<S>, state: StateValue?) -> (Action) -> Observable<(StateKeyPath<S>, StateValue?)> {
    return { action in
        guard let prevState = state as? Int else { return Observable.just((name, 0)) }
        
        switch action {
        case let increaseAction as IncreaseAction:
            return Observable.just((name, prevState + increaseAction.payload))
        case let decreaseAction as DecreaseAction:
            return Observable.just((name, prevState + decreaseAction.payload))
        default:
            return Observable.just((name, prevState))
        }
    }
}
