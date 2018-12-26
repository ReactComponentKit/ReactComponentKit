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
    let rx_sections =  BehaviorRelay<[DefaultSectionModel]>(value: [])
    
    override init() {
        super.init()
        store.set(
            initialState: TableViewState(),
            reducers: [
                todoReducer
            ],
            postwares: [
                makeTodoSectionModels,
                consoleLogPostware
            ])
    }
    
    override func on(newState: TableViewState) {
        rx_sections.accept(newState.sections)
    }
}
