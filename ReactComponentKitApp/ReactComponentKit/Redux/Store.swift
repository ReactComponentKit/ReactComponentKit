//
//  Store.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift

public class ActionWrapper {
    fileprivate let action: Action
    fileprivate init(action: Action) {
        self.action = action
    }
}

public class Flowable<S: State> {
    fileprivate func flow(_ action: ActionWrapper) -> Single<S>? {
        return nil
    }
}

public class Flow<S: State, A: Action>: Flowable<S> {
    private var reducerList: [Reducer<S, A>]
    private weak var weakStore: Store<S>? = nil
    
    internal init(store: Store<S>) {
        self.weakStore = store
        self.reducerList = []
    }
            
    public func flow(_ reducers: Reducer<S, A>...) {
        reducerList.append(contentsOf: reducers)
    }
        
    fileprivate override func flow(_ action: ActionWrapper) -> Single<S>? {
       return Single.create { [weak self] single -> Disposable in
           guard
               let strongSelf = self
           else {
               return Disposables.create()
           }

           strongSelf.reducerList.forEach { (reducer) in
               guard let storeState = strongSelf.weakStore?.state else { return }
               guard let typedAction = action.action as? A else { return }
               let newState = reducer(storeState, typedAction)
               if let newState = newState {
                   strongSelf.weakStore?.state = newState
                   if newState.error?.error != nil {
                       return
                   }
               }
           }

           if let error = strongSelf.weakStore?.state.error?.error {
               single(.error(error))
           } else if let newState = strongSelf.weakStore?.state {
               single(.success(newState))
           }

           return Disposables.create()
       }
    }
}

public final class Store<S: State> {
    var state: S
    private var beforeActionFlow: ((Action) -> Action)? = nil
    private var actionFlowMap: [String: Flowable<S>] = [:]
    private var effects: [Effect<S>]
    private let disposeBag = DisposeBag()
    
    public init() {
        self.state = S()
        self.beforeActionFlow = nil
        self.actionFlowMap = [:]
        self.effects = []
    }
    
    public func initial(state: S) {
        self.state = state
        self.actionFlowMap = [:]
        self.effects = []
    }
    
    public func deinitialize() {
        self.actionFlowMap.removeAll()
        self.effects.removeAll()
    }
    
    public func beforeActionFlow(_ actionFlow: @escaping (Action) -> Action) {
        self.beforeActionFlow = actionFlow
    }
        
    public func flow<A: Action>(action: A.Type) -> Flow<S, A> {
        let flow = Flow<S, A>(store: self)
        actionFlowMap[action.name] = flow
        return flow
    }
    
    public func afterStateFlow(_ effects: Effect<S>...) {
        self.effects = effects
    }
    
    internal func startFlow(action: Action) -> Action {
        return beforeActionFlow?(action) ?? action
    }
    
    internal func doAfterEffects() {
        var mutatedState = state
        effects.forEach { (effect) in
            mutatedState = effect(mutatedState)
        }
        state = mutatedState
    }
    
    public func dispatch(action: Action) -> Single<S> {
        let immutableState = self.state
        return Single.create(subscribe: { [weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.success(immutableState))
                return Disposables.create()
            }
            
            strongSelf.state.error = nil
            let disposeBag = strongSelf.disposeBag
            
            let actionName = type(of: action.self).name
            let actionFlowQ = strongSelf.actionFlowMap[actionName]
            if let actionFlow = actionFlowQ {
                let actionWrapper = ActionWrapper(action: action)
                if let flowResult = actionFlow.flow(actionWrapper) {
                    flowResult
                        .subscribeOn(Q.concurrentQ)
                        .observeOn(Q.concurrentQ)
                        .subscribe(onSuccess: { (newState) in
                            single(.success(newState))
                        }, onError: { error in
                            strongSelf.state.error = RCKError(error: error, action: action)
                            single(.success(strongSelf.state))
                        })
                        .disposed(by: disposeBag)
                }
            }
            return Disposables.create()
        })
    }
}
