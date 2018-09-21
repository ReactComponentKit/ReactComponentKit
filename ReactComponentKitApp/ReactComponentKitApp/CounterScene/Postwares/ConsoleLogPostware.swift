//
//  ConsoleLogPostware.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux
import RxSwift

func consoleLogPostware(state: State, action: Action) -> Observable<State> {
    print("[## LOGGING ##] action: \(String(describing: action)) :: state: \(state)")
    return Observable.just(state)
}
