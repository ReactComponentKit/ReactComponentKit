//
//  Store.swift
//  ReactComponentKit
//
//  Created by burt on 2018. 7. 21..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKEventBus
import RxSwift

class Store {
    
    enum Event: EventType {
        case dispatch(state: StateType, action: ActionType)
        case on(state: StateType, action: ActionType)
    }
    
    static let instance = Store()
    private var stateList: [String:StateType] = [:]
    private let eventBus = EventBus<Store.Event>()
    private let disposeBag = DisposeBag()
    private let concurrentQueue = ConcurrentDispatchQueueScheduler(qos: .background)
    
    private init() {
        setupEventBus()
        setupStateList()
    }

    private func setupEventBus() {
        eventBus.on { [weak self] (event: Store.Event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .dispatch(state, action):
                strongSelf.reduce(state: state, action: action)
                    .subscribeOn(strongSelf.concurrentQueue)
                    .observeOn(strongSelf.concurrentQueue)
                    // middleware
                    .observeOn(MainScheduler.asyncInstance)
                    .subscribe(onNext: { (state: StateType) in
                        
                    }, onError: { (error) in
                        
                    }, onCompleted: {
                        
                    })
                    .disposed(by: strongSelf.disposeBag)
            default:
                break
            }
        }
    }
    
    // 이 부분이 계속 늘어 날 것이다.
    // 어떻게 늘려줄 것인가?
    // Store를 상속해서 써야 한다.
    // 그렇다면 ViewController의 ViewModel이 필요한가?
    private func reduce(state: StateType, action: ActionType) -> Observable<StateType> {
        return Observable.create({ (subject) -> Disposable in
            switch action {
            case let caction as ActionButton.Action:
                switch caction {
                case .changeColor:
                    print("와우")
                }
            default:
                break
            }
            
            return Disposables.create()
        })
    }
    
    private func setupStateList() {
        if let (id, state) = setupState() {
            stateList[id] = state
        }
    }
    
    func setupState() -> (String, StateType)? {
        return nil
    }
}
