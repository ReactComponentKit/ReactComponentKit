//
//  TodoReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import RxSwift

func todoReducer(state: State, action: Action) -> Observable<State> {
    guard var mutableState = state as? TableViewState else { return .just(state) }
    
    if let act = action as? AddTodoAction {
        mutableState.todo.append(act.payload)
    }
    
    return .just(mutableState)
}
