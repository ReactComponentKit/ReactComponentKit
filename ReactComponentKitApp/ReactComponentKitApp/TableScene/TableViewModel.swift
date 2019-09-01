//
//  TableViewModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

struct TableViewState: State {
    var todo: [String] = []
    var sections: [DefaultSectionModel] = []
    var error: RCKError? = nil
}

class TableViewModel: RCKViewModel<TableViewState> {
    
    let sections =  Output<[DefaultSectionModel]>(value: [])
    
    override init() {
        super.init()
        store.set(
            initialState: TableViewState(),
            reducers: [
                todoReducer,
                makeTodoSectionModels,
                consoleLog
            ])
    }
    
    override func on(newState: TableViewState) {
        sections.accept(newState.sections)
    }
}
