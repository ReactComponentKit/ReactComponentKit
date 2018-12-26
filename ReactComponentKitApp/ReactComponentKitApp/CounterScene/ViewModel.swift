//
//  ViewModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux
import RxSwift
import RxCocoa

struct CounterSceneState: State {
    var count: Int = 0
    var color: UIColor = .white
    var error: (Error, Action)? = nil
}

class ViewModel: ViewModelType<CounterSceneState> {
    
    let rx_count =  BehaviorRelay<String>(value: "0")
    let rx_color = BehaviorRelay<UIColor>(value: UIColor.white)
    
    override init() {
        super.init()

        // STORE
        store.set(
            initialState: CounterSceneState(),
            middlewares: [
                printCacheValue,
                consoleLogMiddleware
            ],
            reducers: [
                countReducer,
                colorReducer
            ],
            postwares: [
                cachePostware
            ]
        )
    }
    
    override func on(newState: CounterSceneState) {
        rx_count.accept(String(newState.count))
        rx_color.accept(newState.color)
    }
    
    override func on(error: Error, action: Action, onState: CounterSceneState) {
        
    }
    
    deinit {
        print("[## deinit ##]")
    }
}
