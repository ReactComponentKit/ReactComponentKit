//
//  Reducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift

typealias State = Any
struct ReducerResult {
    let name: String
    let result: State?
}
typealias Reducer = (State?) -> (Action) -> Observable<ReducerResult>
