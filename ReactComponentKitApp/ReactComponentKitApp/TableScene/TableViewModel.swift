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

class TableViewModel: RootViewModelType {
    
    //let rx_tableViewSectionModelList =  BehaviorRelay<String>(value: "0")
    
    
    override init() {
        super.init()
        store.set(state: [
                "todo": [String](),
            ],
            reducers: [
                "todo": todoReducer
            ],
            middlewares: [
                consoleLogMiddleware
            ],
            postwares: [
                consoleLogPostware
            ])
    }
    
    override func on(newState: [String : State]?) {
        // 테이블뷰 섹션 모델을 만들어야 함
        
        // 컴포넌트에게 신규 이벤트를 전달함
        eventBus.post(event: .on(state: newState))
    }
}
