//
//  Store.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift

public final class Store {
    
    public static let concurrentQ = ConcurrentDispatchQueueScheduler(qos: .background)
    public static let serialQ = SerialDispatchQueueScheduler(qos: .background)
    
    private(set) var state: [String:State]
    private(set) var reducers: [String:Reducer]
    private(set) var middlewares: [Middleware]
    private(set) var postwares: [Postware]
    private let disposeBag = DisposeBag()
    
    public init() {
        self.state = [:]
        self.reducers = [:]
        self.middlewares = []
        self.postwares = []
    }
    
    public func set(state: [String:State], reducers:[String:Reducer], middlewares:[Middleware] = [], postwares:[Postware] = []) {
        self.state = state
        self.reducers = reducers
        self.middlewares = middlewares
        self.postwares = postwares
    }
    
    public func dispatch(action: Action) -> Single<[String:State]> {
        /*
         - 이렇게 할 경우, API를 호출했을 때, 응답을 받은 후 응답의 각 level-0 필드를 분해한 다음,
         - 다시 리듀서를 탈 수 있는가?
         - store(API response) -> store(각 필드를 쪼갠것)?
         - 아니면 상태를
         - {
         -      response: {}, --> responseReducer
         -      converted: {} --> convertReducer
         - }
         - 이렇게 정의해야 하는가?
         - 예제를 작성해서 방법을 찾아보자
         - 아!
         - 스토어는 모든 상태를 가져야 하므로 모든 API에 대한 응답을 가지고 있어야 한다. 즉, 아래처럼
         - {
         -      A_API_response: {} --> A_API_Reducer
         -      B_API_response: {} --> B_API_Reducer
         -      C_API_response: {} --> C_API_Reducer
         - }
         - 하면서 A_API_Reducer에서 하위 상태를 위한 리듀서를 직접 호출해야 한다. 
        */
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.success([:]))
                return Disposables.create()
            }
            
            let state = strongSelf.state
            let disposeBag = strongSelf.disposeBag
            if strongSelf.middlewares.isEmpty == false {
                strongSelf.middleware(state: state, action: action)
                    .subscribeOn(Store.concurrentQ)
                    .observeOn(Store.concurrentQ)
                    .flatMap({ [weak self] (middlewareState) -> Observable<[String:State]> in
                        guard let strongSelf = self else { return Observable.just(middlewareState) }
                        return strongSelf.reduce(state: middlewareState, action: action)
                    })
                    .observeOn(Store.serialQ)
                    // Needs to do some action for example, request api
                    // Action 이 비동기 람다를 갖도록 하자
                    // flatMap 으로 체인을 걸자
                    .observeOn(Store.concurrentQ)
                    .flatMap({ [weak self] (reducesState) -> Observable<[String:State]> in
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
                        mutableState["error"] = (error, action)
                        single(.success(mutableState))
                    })
                    .disposed(by: disposeBag)
            } else {
                
                strongSelf.reduce(state: state, action: action)
                    .subscribeOn(Store.concurrentQ)
                    .observeOn(Store.concurrentQ)
                    .flatMap({ [weak self] (reducesState) -> Observable<[String:State]> in
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
                        mutableState["error"] = (error, action)
                        single(.success(mutableState))
                    })
                    .disposed(by: disposeBag)
            }
            
            
            
            return Disposables.create()
        })
        
    }
    
    
    private func middleware(state: [String:State], action: Action) -> Observable<[String:State]> {
        
        var mutableState = state
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.success(state))
                return Disposables.create()
            }

            mutableState = strongSelf.middlewares.reduce(mutableState, { (nextState, m) -> [String:State] in
                return m(nextState, action)
            })
            
            single(.success(mutableState))
            return Disposables.create()
            
        }).asObservable()
    }
    
    private func reduce(state: [String:State], action: Action) -> Observable<[String:State]> {
        
        var mutableState = state
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.success(mutableState))
                return Disposables.create()
            }
            
            let statedReducers = strongSelf.reducers.map({ (reducerInfo) -> (Action) -> Observable<ReducerResult> in
                let (key, reducer) = reducerInfo
                return reducer(key, mutableState[key])
            })
            
            return Observable.combineLatest(statedReducers.map({ $0(action) }))
                .subscribeOn(Store.concurrentQ)
                .observeOn(Store.concurrentQ)
                .subscribe(onNext: { (reducerResultList: [ReducerResult]) in
                    reducerResultList.forEach({ (reducerResult: ReducerResult) in
                        mutableState[reducerResult.name] = reducerResult.result
                    })
                    single(.success(mutableState))
                }, onError: { (error) in
                    // 오류 발생시에는 액션에 따라 오류를 처리할지 말지 결정하기 위해서 오류와 액션을 동시에 넣어준다.
                    mutableState["error"] = (error, action)
                    single(.success(mutableState))
                })

        }).asObservable()
        
    }
    
    private func postware(state: [String:State], action: Action) -> Observable<[String:State]> {
        
        var mutableState = state
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.success(state))
                return Disposables.create()
            }
            
            mutableState = strongSelf.postwares.reduce(mutableState, { (nextState, p) -> [String:State] in
                return p(nextState, action)
            })
            
            single(.success(mutableState))
            return Disposables.create()
            
        }).asObservable()
    }
    
    
    
}
