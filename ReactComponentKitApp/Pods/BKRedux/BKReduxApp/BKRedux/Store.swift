//
//  Store.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift

private enum Q {
    fileprivate static let serialQ = SerialDispatchQueueScheduler(qos: .background)
    fileprivate static let concurrentQ = ConcurrentDispatchQueueScheduler(qos: .background)
}

public final class Store<S: State> {
    
    public private(set) var state: S
    private(set) var reducers: [Reducer]
    private(set) var middlewares: [Middleware]
    private(set) var postwares: [Postware]
    private let disposeBag = DisposeBag()
    
    public init() {
        self.state = S()
        self.middlewares = []
        self.reducers = []
        self.postwares = []
    }
    
    public func deinitialize() {
        self.middlewares.removeAll()
        self.reducers.removeAll()
        self.postwares.removeAll()
    }
    
    public func set(initialState: S, middlewares:[Middleware] = [], reducers:[Reducer] = [], postwares:[Postware] = []) {
        self.state = initialState
        self.reducers = reducers
        self.middlewares = middlewares
        self.postwares = postwares
    }
    
    public func dispatch(action: Action) -> Single<State> {
        let immutableState = self.state
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.success(immutableState))
                return Disposables.create()
            }
            
            strongSelf.state.error = nil
            let disposeBag = strongSelf.disposeBag
            
            strongSelf.middleware(state: strongSelf.state, action: action)
                .subscribeOn(Q.serialQ)
                .observeOn(Q.serialQ)
                .flatMap({ [weak self] (middlewareState) -> Observable<State> in
                    guard let strongSelf = self else { return Observable.just(middlewareState) }
                    return strongSelf.reduce(state: middlewareState, action: action)
                })
                .flatMap({ [weak self] (reducesState) -> Observable<State> in
                    guard let strongSelf = self else { return Observable.just(reducesState) }
                    return strongSelf.postware(state: reducesState, action: action)
                })
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { (newState) in
                    if let newS = newState as? S {
                        strongSelf.state = newS
                    }
                    single(.success(strongSelf.state))
                }, onError: { (error) in
                    // 오류 발생시에는 액션에 따라 오류를 처리할지 말지 결정하기 위해서 오류와 액션을 동시에 넣어준다.
                    strongSelf.state.error = (error, action)
                    single(.success(strongSelf.state))
                })
                .disposed(by: disposeBag)
            
            return Disposables.create()
        })
    }    
    
    private func middleware(state: State, action: Action) -> Observable<State> {
        guard middlewares.isEmpty == false else { return .just(state) }
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.success(state))
                return Disposables.create()
            }

            Observable.from(strongSelf.middlewares)
                .subscribeOn(Q.serialQ)
                .observeOn(Q.serialQ)
                .flatMap({ (m: Middleware) -> Observable<State> in
                    return m(strongSelf.state, action)
                })
                .do(onNext: { (modifiedState) in
                    if let modifiedS = modifiedState as? S {
                        strongSelf.state = modifiedS
                    }
                })
                .reduce(strongSelf.state, accumulator: { (ignore, nextState) -> State in
                    return nextState
                })
                .subscribe(onNext: { (finalState) in
                    if let finalS = finalState as? S {
                        strongSelf.state = finalS
                    }
                    single(.success(strongSelf.state))
                }, onError: { (error) in
                    // 오류 발생시에는 액션에 따라 오류를 처리할지 말지 결정하기 위해서 오류와 액션을 동시에 넣어준다.
                    strongSelf.state.error = (error, action)
                    single(.success(strongSelf.state))
                })
                .disposed(by: strongSelf.disposeBag)

            return Disposables.create()
        }).asObservable()
    }
    
    private func reduce(state: State, action: Action) -> Observable<State> {
        guard reducers.isEmpty == false, state.error == nil else { return .just(state) }
        
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.success(state))
                return Disposables.create()
            }
            
            Observable.from(strongSelf.reducers)
                .subscribeOn(Q.serialQ)
                .observeOn(Q.serialQ)
                .flatMap({ (r: Reducer) -> Observable<State> in
                    return r(strongSelf.state, action)
                })
                .do(onNext: { (modifiedState) in
                    if let modifiedS = modifiedState as? S {
                        strongSelf.state = modifiedS
                    }
                })
                .reduce(strongSelf.state, accumulator: { (ignore, nextState) -> State in
                    return nextState
                })
                .subscribe(onNext: { (finalState) in
                    if let finalS = finalState as? S {
                        strongSelf.state = finalS
                    }
                    single(.success(strongSelf.state))
                }, onError: { (error) in
                    // 오류 발생시에는 액션에 따라 오류를 처리할지 말지 결정하기 위해서 오류와 액션을 동시에 넣어준다.
                    strongSelf.state.error = (error, action)
                    single(.success(strongSelf.state))
                })
                .disposed(by: strongSelf.disposeBag)
            
            return Disposables.create()
        }).asObservable()
    }
    
    private func postware(state: State, action: Action) -> Observable<State> {
        guard postwares.isEmpty == false, state.error == nil else { return .just(state) }
        
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.success(state))
                return Disposables.create()
            }
            
            Observable.from(strongSelf.postwares)
                .subscribeOn(Q.serialQ)
                .observeOn(Q.serialQ)
                .flatMap({ (p: Postware) -> Observable<State> in
                    return p(strongSelf.state, action)
                })
                .do(onNext: { (modifiedState) in
                    if let modifiedS = modifiedState as? S {
                        strongSelf.state = modifiedS
                    }
                })
                .reduce(strongSelf.state, accumulator: { (ignore, nextState) -> State in
                    return nextState
                })
                .subscribe(onNext: { (finalState) in
                    if let finalS = finalState as? S {
                        strongSelf.state = finalS
                    }
                    single(.success(strongSelf.state))
                }, onError: { (error) in
                    // 오류 발생시에는 액션에 따라 오류를 처리할지 말지 결정하기 위해서 오류와 액션을 동시에 넣어준다.
                    strongSelf.state.error = (error, action)
                    single(.success(strongSelf.state))
                })
                .disposed(by: strongSelf.disposeBag)
            
            return Disposables.create()
        }).asObservable()
    }
}
