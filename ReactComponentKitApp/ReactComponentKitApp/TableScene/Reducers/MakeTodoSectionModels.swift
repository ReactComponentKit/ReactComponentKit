//
//  MakeTodoSectionModels.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux
import RxSwift

func makeTodoSectionModels(state: State, action: Action) -> Observable<State> {
    guard
        let tableViewState = state as? TableViewState,
        type(of: action) == AddTodoAction.self
    else {
        return Observable.just(state)
    }
    
    let todoItemList = tableViewState.todo.map { (todo) -> TodoItem in
        TodoItem(item: todo)
    }
    
    let section0 = DefaultSectionModel(items: todoItemList, header: TodoSectionHeaderModel(title: "Section Header"), footer: TodoSectionFooterModel(title: "Section Footer"))
    let section1 = DefaultSectionModel(items: todoItemList, header: TodoSectionHeaderModel(title: "Section Header"), footer: TodoSectionFooterModel(title: "Section Footer"))
    let section2 = DefaultSectionModel(items: todoItemList, header: TodoSectionHeaderModel(title: "Section Header"), footer: TodoSectionFooterModel(title: "Section Footer"))
    var newState = tableViewState
    newState.sections = [section0, section1, section2]
    return Observable.just(newState)
}
