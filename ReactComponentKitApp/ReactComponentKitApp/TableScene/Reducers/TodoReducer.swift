//
//  TodoReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import RxSwift

func todoReducer(state: TableViewState, action: AddTodoAction) -> TableViewState {
    var mutableState = state
    mutableState.todo.append(action.payload)
    return mutableState
}
