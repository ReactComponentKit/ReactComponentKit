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

public typealias Reducer<S: State, A: Action> = (S, A) -> S?
public typealias AsyncReducer<S: State, A: Action> = (A) -> Observable<S>
