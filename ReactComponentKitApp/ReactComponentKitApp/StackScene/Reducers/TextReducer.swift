//
//  TextReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 2..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux
import RxSwift

func textReducer(name: String, state: State?) -> (Action) -> Observable<ReducerResult> {
    return { action in
        guard let prevState = state as? String else { return Observable.just(ReducerResult(name: name, result: state)) }
        
        if let textAction = action as? TextAction {
            return Observable.just(ReducerResult(name: name, result: prevState + " \(textAction.payload)"))
        }
        
        return Observable.just(ReducerResult(name: name, result: prevState))
    }
}
