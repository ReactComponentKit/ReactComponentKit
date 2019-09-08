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


class CollectionViewModel: RCKViewModel<TableViewState> {
    let sections =  Output<[DefaultSectionModel]>(value: [])
    
    override func setupStore() {
        initStore { (store) in
            store.initial(state: TableViewState())
            store.beforeActionFlow { logAction(action: $0) }
            store.flow(action: AddTodoAction.self)
                .flow(todoReducer, makeTodoSectionModels)
        }
    }
    
    override func on(newState: TableViewState) {
        sections.accept(newState.sections)
    }
}
