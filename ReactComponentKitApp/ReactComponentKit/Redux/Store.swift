//
//  Store.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift

private class RFunctor<S: State, A: Action> {
    private let reducer: Reducer<S, A>
    init(reducer: @escaping Reducer<S, A>) {
        self.reducer = reducer
    }
    
    func invoke(state: State, action: Action) -> State {
        guard let ss = state as? S else { return state }
        guard let aa = action as? A else { return state }
        return reducer(ss, aa)
    }
}

private class Flow<S: State> {
    private var reducerList: [RFunctor<S,Action>]
    private weak var weakStore: Store<S>? = nil
    
    init(store: Store<S>) {
        self.weakStore = store
        self.reducerList = []
    }
        
    func registerReducers(_ rlist: [RFunctor<S, Action>]) {
        self.reducerList = rlist
    }
    
    func flow<A: Action>(action: A) -> Single<S> {
        return Single.create { [weak self] single -> Disposable in
            guard
                let strongSelf = self
            else {
                return Disposables.create()
            }
            
            strongSelf.reducerList.forEach { (anyValue) in
                guard let storeState = strongSelf.weakStore?.state else { return }
                guard let reducer = anyValue as? RFunctor<S, A> else {
                    print("Fuck!!!")
                    return
                }
                let newState = reducer.invoke(state: storeState, action: action) as? S
                if let newState = newState {
                    strongSelf.weakStore?.state = newState
                }
            }
            
            if let newState = strongSelf.weakStore?.state {
                single(.success(newState))
            }
            
            return Disposables.create()
        }
    }
}

public final class Store<S: State> {
    var state: S
    private var actionFlowMap: [String: Flow<S>]
    private var effects: [Effect<S>]
    private let disposeBag = DisposeBag()
    
    public init() {
        self.state = S()
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
        
    public func flow<A: Action>(action: A.Type, _ reducers: Reducer<S, Action>...) {
        
        let rfunctors = reducers.compactMap { RFunctor<S, Action>(reducer: $0) }
        
        let flow = Flow<S>(store: self)
        flow.registerReducers(rfunctors)
        let actiionClassName = NSStringFromClass(A.classForCoder())
        actionFlowMap[actiionClassName] = flow
    }
    
    public func afterFlow(_ effects: Effect<S>...) {
        self.effects = effects
    }
    
    func doAfterEffects() {
        var mutatedState = state
        effects.forEach { (effect) in
            mutatedState = effect(mutatedState)
        }
        state = mutatedState
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
            
            let actionClassName = NSStringFromClass(action.classForCoder)
            let actionFlow = strongSelf.actionFlowMap[actionClassName]
            if let actionFlow = actionFlow {
                actionFlow.flow(action: action)
                    .subscribeOn(Q.serialQ)
                    .observeOn(Q.serialQ)
                    .subscribe(onSuccess: { (newState) in
                        single(.success(newState))
                    }, onError: { error in
                        strongSelf.state.error = RCKError(error: error, action: action)
                        single(.success(strongSelf.state))
                    })
                    .disposed(by: disposeBag)
            }
            return Disposables.create()
        })
    }
}
