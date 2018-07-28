//
//  CountReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift

func countReducer(name: String, state: State?) -> (Action) -> Observable<ReducerResult> {
    return { action in
        guard let mutableState = state as? Int else { return Observable.just(ReducerResult(name: name, result: 0)) }
        
        switch action {
        case let increaseAction as IncreaseAction:
            return Observable.just(ReducerResult(name: name, result: mutableState + increaseAction.payload))
        case let decreaseAction as DecreaseAction:
            return Observable.just(ReducerResult(name: name, result: mutableState + decreaseAction.payload))
        default:
            return Observable.just(ReducerResult(name: name, result: mutableState))
        }
    }
}
