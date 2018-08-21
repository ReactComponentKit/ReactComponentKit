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

class CollectionViewModel: RootViewModelType {
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
        guard let sections = newState?["sections"] as? [DefaultSectionModel] else { return }
        rx_sections.accept(sections)
    }
}
