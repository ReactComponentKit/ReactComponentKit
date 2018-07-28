//
//  ViewModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel: ViewModelType {
    
    let rx_count =  BehaviorRelay<String>(value: "0")
    let rx_color = BehaviorRelay<UIColor>(value: UIColor.white)
    
    override init() {
        super.init()

        // STORE
        store.set(
            state: [
                "count": 0,
                "color": UIColor.white
            ],
            reducers: [
                "count": countReducer,
                "color": colorReducer
            ],
            middlewares: [
                printCacheValue,
                consoleLogMiddleware
            ],
            postwares: [
                cachePostware
            ]
        )
    }
    
    override func on(newState: [String : State]?) {
        if let count = newState?["count"] as? Int {
            rx_count.accept(String(count))
        }
        
        if let color = newState?["color"] as? UIColor {
            rx_color.accept(color)
        }
    }
    
    override func on(error: Error, action: Action) {
        
    }
    
    deinit {
        print("[## deinit ##]")
    }
}
