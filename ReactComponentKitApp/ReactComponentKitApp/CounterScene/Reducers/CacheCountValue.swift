//
//  CachePostware.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux
import RxSwift

func cacheCountValue(state: State, action: Action) -> Observable<State> {
    guard let countState = state as? CounterSceneState else { return Observable.just(state) }
    return Single.create(subscribe: { (single) -> Disposable in
        
        UserDefaults.standard.set(countState.count, forKey: "count")
        UserDefaults.standard.synchronize()
        single(.success(countState))
        
        return Disposables.create()
    }).asObservable()
}
