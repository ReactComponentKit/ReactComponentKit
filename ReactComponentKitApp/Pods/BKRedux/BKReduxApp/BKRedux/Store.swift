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
    
    public private(set) var state: State?
    private(set) var reducers: [StateKeyPath<S>:Reducer<S>]
    private(set) var middlewares: [Middleware]
    private(set) var postwares: [Postware]
    private let disposeBag = DisposeBag()
    
    public init() {
        self.state = nil
        self.reducers = [:]
        self.middlewares = []
        self.postwares = []
    }
    
    public func set(initialState: State, middlewares:[Middleware] = [], reducers:[StateKeyPath<S>:Reducer<S>], postwares:[Postware] = []) {
        self.state = initialState
        self.reducers = reducers
        self.middlewares = middlewares
        self.postwares = postwares
    }
    
    public func dispatch(action: Action) -> Single<State?> {
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let strongSelf = self, var state = strongSelf.state else {
                single(.success(nil))
                return Disposables.create()
            }
            
            state.error = nil
            let disposeBag = strongSelf.disposeBag
            
            strongSelf.middleware(state: state, action: action)
                .subscribeOn(Q.concurrentQ)
                .observeOn(Q.concurrentQ)
                .flatMap({ [weak self] (middlewareState) -> Observable<State> in
                    guard let strongSelf = self else { return Observable.just(middlewareState) }
                    return strongSelf.reduce(state: middlewareState, action: action)
                })
                .flatMap({ [weak self] (reducesState) -> Observable<State> in
                    guard let strongSelf = self else { return Observable.just(reducesState) }
                    return strongSelf.postware(state: reducesState, action: action)
                })
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] (newState) in
                    guard let strongSelf = self else { return }
                    strongSelf.state = newState
                    single(.success(newState))
                }, onError: { (error) in
                    // 오류 발생시에는 액션에 따라 오류를 처리할지 말지 결정하기 위해서 오류와 액션을 동시에 넣어준다.
                    var mutableState = state
                    mutableState.error = (error, action)
                    strongSelf.state = mutableState
                    single(.success(mutableState))
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

            var mutableState = state
            Observable.from(strongSelf.middlewares)
                .subscribeOn(Q.serialQ)
                .observeOn(Q.serialQ)
                .flatMap({ (m: Middleware) -> Observable<State> in
                    return m(mutableState, action)
                })
                .do(onNext: { (modifiedState) in
                    mutableState = modifiedState
                })
                .reduce(mutableState, accumulator: { (ignore, nextState) -> State in
                    return nextState
                })
                .subscribe(onNext: { (finalState) in
                    single(.success(finalState))
                })
                .disposed(by: strongSelf.disposeBag)
            
            return Disposables.create()
        }).asObservable()
    }
    
    private func reduce(state: State, action: Action) -> Observable<State> {
        guard reducers.isEmpty == false else { return .just(state) }
        
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let strongSelf = self, var mutableState = state as? S else {
                single(.success(state))
                return Disposables.create()
            }
            
            let statedReducers = strongSelf.reducers.map({ (keyPathToReducer) -> (Action) -> Observable<(StateKeyPath<S>, StateValue?)> in
                let (keyPath, reducer) = keyPathToReducer
                return reducer(keyPath, mutableState[keyPath: keyPath.anyKeyPath])
            })
            
            return Observable.combineLatest(statedReducers.map({ $0(action) }))
                .subscribeOn(Q.concurrentQ)
                .observeOn(Q.concurrentQ)
                .subscribe(onNext: { (stateValueList) in
                    stateValueList.forEach({ (arg) in
                        let (keyPath, stateValue) = arg
                        mutableState = keyPath.apply(value: stateValue, to: mutableState)
                    })
                    single(.success(mutableState))
                }, onError: { (error) in
                    // 오류 발생시에는 액션에 따라 오류를 처리할지 말지 결정하기 위해서 오류와 액션을 동시에 넣어준다.
                    mutableState.error = (error, action)
                    single(.success(mutableState))
                })

        }).asObservable()
    }
    
    private func postware(state: State, action: Action) -> Observable<State> {
        guard postwares.isEmpty == false else { return .just(state) }
        
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.success(state))
                return Disposables.create()
            }
            
            var mutableState = state
            Observable.from(strongSelf.postwares)
                .subscribeOn(Q.serialQ)
                .observeOn(Q.serialQ)
                .flatMap({ (p: Postware) -> Observable<State> in
                    return p(mutableState, action)
                })
                .do(onNext: { (modifiedState) in
                    mutableState = modifiedState
                })
                .reduce(mutableState, accumulator: { (ignore, nextState) -> State in
                    return nextState
                })
                .subscribe(onNext: { (finalState) in
                    single(.success(finalState))
                })
                .disposed(by: strongSelf.disposeBag)
            
            return Disposables.create()
        }).asObservable()
    }
}
