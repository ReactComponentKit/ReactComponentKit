//
//  TodoReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux
import RxSwift

func todoReducer(name: String, state: State?) -> (Action) -> Observable<ReducerResult> {
    return { action in
        guard let prevState = state as? [String] else { return Observable.just(ReducerResult(name: name, result: state)) }
        
        if let addTodoAction = action as? AddTodoAction {
            var newState = prevState
            newState.append(addTodoAction.payload)
            return Observable.just(ReducerResult(name: name, result: newState))
        }
        
        return Observable.just(ReducerResult(name: name, result: prevState))
    }
}
