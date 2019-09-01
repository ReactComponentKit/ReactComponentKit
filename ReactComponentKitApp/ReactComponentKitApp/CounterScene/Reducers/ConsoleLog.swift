//
//  ConsoleLogMiddleware.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import RxSwift

func consoleLog(state: State, action: Action) -> Observable<State> {
    print("[## LOGGING ##] action: \(String(describing: action)) :: state: \(state)")
    return Observable.just(state)
}
