//
//  TableViewModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKRedux
import BKEventBus
import RxCocoa

struct TableViewState: State {
    var todo: [String] = []
    var sections: [DefaultSectionModel] = []
    var error: (Error, Action)? = nil
}

class TableViewModel: RootViewModelType<TableViewState> {
    
    let rx_sections =  BehaviorRelay<[DefaultSectionModel]>(value: [])
    
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
        rx_sections.accept(newState.sections)
    }
}
