//
//  Reducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift

public typealias State = Any
public struct ReducerResult {
    public let name: String
    public let result: State?
    public init(name: String, result: State?) {
        self.name = name
        self.result = result
    }
}
public typealias Reducer = (String, State?) -> (Action) -> Observable<ReducerResult>
