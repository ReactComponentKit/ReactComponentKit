//
//  ColorReducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 28..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux
import RxSwift
import UIKit

func colorReducer<S>(name: StateKeyPath<S>, state: StateValue?) -> (Action) -> Observable<(StateKeyPath<S>, StateValue?)> {
    return { action in
        guard let prevState = state as? UIColor else { return Observable.just((name, UIColor.white)) }
        
        if let colorAction = action as? RandomColorAction {
            return Observable.just((name, colorAction.payload))
        }
        return Observable.just((name, prevState))
    }
}
