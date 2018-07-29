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

func colorReducer(name: String, state: State?) -> (Action) -> Observable<ReducerResult> {
    return { action in
        guard let prevState = state as? UIColor else { return Observable.just(ReducerResult(name: name, result: UIColor.white)) }
        
        if let colorAction = action as? RandomColorAction {
            return Observable.just(ReducerResult(name: name, result: colorAction.payload))
        }
        return Observable.just(ReducerResult(name: name, result: prevState))
    }
}
