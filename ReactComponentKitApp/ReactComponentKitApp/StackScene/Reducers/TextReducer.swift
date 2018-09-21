//
//  TextReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 2..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux
import RxSwift

func textReducer<S>(name: StateKeyPath<S>, state: StateValue?) -> (Action) -> Observable<(StateKeyPath<S>, StateValue?)> {
    return { action in
        guard let prevState = state as? String else { return Observable.just((name, state)) }
        
        if let textAction = action as? TextAction {
            return Observable.just((name, prevState + " \(textAction.payload)"))
        }
        
        return Observable.just((name, prevState))
    }
}
