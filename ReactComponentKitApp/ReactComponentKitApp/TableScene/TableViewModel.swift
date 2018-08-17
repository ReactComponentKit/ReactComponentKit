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

class TableViewModel: RootViewModelType {
    
    let rx_sections =  BehaviorRelay<[DefaultSectionModel]>(value: [])
    
    override init() {
        super.init()
        store.set(state: [
                "todo": [String](),
            ],
            reducers: [
                "todo": todoReducer
            ],
            postwares: [
                makeTodoSectionModels,
                consoleLogPostware
            ])
    }
    
    override func on(newState: [String : State]?) {
        guard let reload = newState?["reload"] as? Bool, reload == true else { return }
        guard let sections = newState?["sections"] as? [DefaultSectionModel] else { return }
        rx_sections.accept(sections)
    }
}
