//
//  MakeTodoSectionModels.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux

func makeTodoSectionModels(state: [String:State], action: Action) -> [String:State] {
    if type(of: action) != AddTodoAction.self { return state }
    
    if let todoList = state["todo"] as? [String] {
        let todoItemList = todoList.map { (todo) -> TodoItem in
            TodoItem(item: todo)
        }
        
        let section0 = DefaultSectionModel(items: todoItemList, header: TodoSectionHeaderModel(title: "Section Header"), footer: TodoSectionFooterModel(title: "Section Footer"))
        let section1 = DefaultSectionModel(items: todoItemList, header: TodoSectionHeaderModel(title: "Section Header"), footer: TodoSectionFooterModel(title: "Section Footer"))
        let section2 = DefaultSectionModel(items: todoItemList, header: TodoSectionHeaderModel(title: "Section Header"), footer: TodoSectionFooterModel(title: "Section Footer"))
        var newState = state
        newState["sections"] = [section0, section1, section2]
        return newState
    }
    
    return state
}
