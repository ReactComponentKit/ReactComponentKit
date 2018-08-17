//
//  MakeTodoSectionModels.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux

func makeTodoSectionModels(state: [String:State], action: Action) -> [String:State] {
    if type(of: action) != AddTodoAction.self {
        var newState = state
        newState["reload"] = false
        return newState
    }
    
    if let todoList = state["todo"] as? [String] {
        let todoItemList = todoList.map { (todo) -> TodoItem in
            TodoItem(item: todo)
        }
        
        let section = DefaultSectionModel(items: todoItemList, header: TodoSectionHeaderModel(title: "섹션헤더"), footer: TodoSectionFooterModel(title: "섹션푸터 ㅎㅎ"))
        var newState = state
        newState["sections"] = [section, section, section]
        newState["reload"] = true
        return newState
    }
    
    return state
}
