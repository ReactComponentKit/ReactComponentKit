//
//  CollectionViewModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 19..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BKRedux
import BKEventBus



class CollectionViewModel: RootViewModelType<TableViewState> {
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
