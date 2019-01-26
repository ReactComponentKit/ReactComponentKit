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
    private let disposeBag = DisposeBag()
    
    public init() {
        self.state = S()
        self.reducers = []
    }
    
    public func deinitialize() {
        self.reducers.removeAll()
    }
    
    public func set(initialState: S, reducers: [Reducer] = []) {
        self.state = initialState
        self.reducers = reducers
    }
    
    public func dispatch(action: Action) -> Single<State> {
        let state = self.state
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard
                let strongSelf = self,
                strongSelf.reducers.isEmpty == false
            else {
                single(.success(state))
                return Disposables.create()
            }

            strongSelf.state.error = nil
            Observable.from(strongSelf.reducers)
                .subscribeOn(Q.serialQ)
                .observeOn(Q.serialQ)
                .flatMap({ (r: Reducer) -> Observable<State> in
                    return r(strongSelf.state, action)
                })
                .do(onNext: { (modifiedState: State) in
                    if let modifiedS = modifiedState as? S {
                        strongSelf.state = modifiedS
                    }
                })
                .reduce(strongSelf.state, accumulator: { (ignore, newState) -> State in
                    return newState
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
        })
    }
}
