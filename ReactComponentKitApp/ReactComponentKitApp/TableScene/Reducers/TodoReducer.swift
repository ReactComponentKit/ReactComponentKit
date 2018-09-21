//
//  TodoReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux
import RxSwift

func todoReducer<S>(name: StateKeyPath<S>, state: StateValue?) -> (Action) -> Observable<(StateKeyPath<S>, StateValue?)> {
    return { action in
        guard let prevState = state as? [String] else { return Observable.just((name, state)) }
        
        if let addTodoAction = action as? AddTodoAction {
            var newState = prevState
            newState.append(addTodoAction.payload)
            return Observable.just((name, newState))
        }
        
        return Observable.just((name, prevState))
    }
}
