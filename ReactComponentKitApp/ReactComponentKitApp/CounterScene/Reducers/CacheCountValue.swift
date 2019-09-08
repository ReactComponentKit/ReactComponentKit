//
//  CachePostware.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import RxSwift

func cacheCountValue(state: CounterSceneState, action: Action) -> CounterSceneState {
    UserDefaults.standard.set(state.count, forKey: "count")
    UserDefaults.standard.synchronize()    
    return state
}
