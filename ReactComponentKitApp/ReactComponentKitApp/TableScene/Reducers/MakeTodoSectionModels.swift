//
//  MakeTodoSectionModels.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import RxSwift

func makeTodoSectionModels(state: TableViewState, action: AddTodoAction) -> TableViewState {
    var mutableState = state
    let todoItemList = mutableState.todo.map { (todo) -> TodoItem in
        TodoItem(item: todo)
    }
    
    let section0 = DefaultSectionModel(items: todoItemList, header: TodoSectionHeaderModel(title: "Section Header"), footer: TodoSectionFooterModel(title: "Section Footer"))
    let section1 = DefaultSectionModel(items: todoItemList, header: TodoSectionHeaderModel(title: "Section Header"), footer: TodoSectionFooterModel(title: "Section Footer"))
    let section2 = DefaultSectionModel(items: todoItemList, header: TodoSectionHeaderModel(title: "Section Header"), footer: TodoSectionFooterModel(title: "Section Footer"))
    mutableState.sections = [section0, section1, section2]
    return mutableState
}
