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
    
    func increase() {
        setState {
            $0.copy { $0.count += 1 }
        }
    }
    
    override func setupStore() {
        initStore { (store) in
            store.initial(state: CounterSceneState())
            
            store.beforeActionFlow { (action) -> Action in
                logAction(action: action)
            }
                        
            store.flow(action: IncreaseAction.self)
                .flow(
                    increaseCount,
                    cacheCountValue,
                    printCachedValue
                )
                    
            store.flow(action: DecreaseAction.self)
                .flow(
                    /* For Testing
                    awaitFlow({ [unowned self] (action) -> Observable<CounterSceneState> in
                        return Single.create { single in
                            Thread.sleep(forTimeInterval: 3)
                            self.withState { state in
                                single(.success(state))
                            }
                            return Disposables.create()
                        }.asObservable()
                    }),
                    */
                    decreaseCount,
                    cacheCountValue,
                    printCachedValue
                )
                
            store.flow(action: RandomColorAction.self)
                .flow(colorReducer)
        }
    }
    
    override func on(newState: CounterSceneState) {
        count.accept(String(newState.count))
        color.accept(newState.color)
    }
    
    override func on(error: RCKError) {
        
    }
    
    deinit {
        print("[## deinit ##]")
    }
}
