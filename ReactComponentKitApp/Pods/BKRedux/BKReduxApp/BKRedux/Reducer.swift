//
//  Reducer.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//
//
//
import RxSwift

public typealias Reducer<S: State> = (StateKeyPath<S>, StateValue?) -> (Action) -> Observable<(StateKeyPath<S>, StateValue?)>
