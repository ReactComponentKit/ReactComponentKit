//
//  ViewModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import RxSwift
import RxCocoa

struct CounterSceneState: State, ColorNibComponentState {
    var count: Int = 0
    var color: UIColor = .white
    var error: RCKError? = nil
}

class ViewModel: RCKViewModel<CounterSceneState> {
    
    let count = Output<String>(value: "0")
    let color = Output<UIColor>(value: UIColor.white)
    
    override func setupStore() {
        initStore { (store) in
            store.initial(state: CounterSceneState())
            store.flow(
                action: IncreaseAction.self,
                printCachedValue,
                increaseCount,
                { state, action in
                    print("TEST")
                    return state
                })
            store.flow(action: DecreaseAction.self, printCachedValue, decreaseCount)
//            store.set(
//                initialState: CounterSceneState(),
//            
//                reducers: [
//                    printCachedValue,
//                    consoleLog,
//                    countReducer,
//                    colorReducer,
//                    cacheCountValue
//                ])
        }
    }
    
    override func on(newState: CounterSceneState) {
        count.accept(String(newState.count))
        color.accept(newState.color)
        //propagate(state: newState)
    }
    
    override func on(error: RCKError) {
        
    }
    
    deinit {
        print("[## deinit ##]")
    }
}
