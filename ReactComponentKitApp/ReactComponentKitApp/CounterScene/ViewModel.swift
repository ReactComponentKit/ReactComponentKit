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

struct CounterSceneState: State, ColorNibComponentState {
    var count: Int = 0
    var color: UIColor = .white
    var error: (Error, Action)? = nil
}

class ViewModel: RootViewModelType<CounterSceneState> {
    
    let count = Output<String>(value: "0")
    let color = Output<UIColor>(value: UIColor.white)
    
    override init() {
        super.init()

        // STORE
        store.set(
            initialState: CounterSceneState(),
            reducers: [
                printCachedValue,
                consoleLog,
                countReducer,
                colorReducer,
                cacheCountValue
            ])
    }
    
    override func on(newState: CounterSceneState) {
        count.accept(String(newState.count))
        color.accept(newState.color)
        propagate(state: newState)
    }
    
    override func on(error: Error, action: Action) {

    }
    
    deinit {
        print("[## deinit ##]")
    }
}
