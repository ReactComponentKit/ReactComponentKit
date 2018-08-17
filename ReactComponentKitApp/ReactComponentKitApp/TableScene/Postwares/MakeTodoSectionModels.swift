//
//  MakeTodoSectionModels.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux

func makeTodoSectionModels(state: [String:State], action: Action) -> [String:State] {
    
    if let todoList = state["todo"] as? [String] {
        let todoItemList = todoList.map { (todo) -> TodoItem in
            TodoItem(item: todo)
        }
        
        let section = DefaultSectionModel(items: todoItemList)
        var newState = state
        newState["sections"] = [section]
        return newState
    }
    
    return state
}
