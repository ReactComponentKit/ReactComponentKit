//
//  PrintCacheValue.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux
import RxSwift

func printCacheValue(state: State, action: Action) -> Observable<State> {
    print("[## CACHED ##] value: \(UserDefaults.standard.integer(forKey: "count"))")
    return  Observable.just(state)
}
