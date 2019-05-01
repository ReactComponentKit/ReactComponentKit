//
//  Output.swift
//  BKReduxApp
//
//  Created by burt on 22/04/2019.
//  Copyright © 2019 Burt.K. All rights reserved.
//

import RxSwift
import RxCocoa
/// Output is a wrapper for `BehaviorRelay`.
///
/// Like as `BehaviorRelay` it can't terminate with error or completed.
/// Output only accepts new value when the current value is not equal to the new value.
public final class Output<Element: Equatable>: ObservableType {
    
    private let _relay: BehaviorRelay<Element>
    
    /// Accepts `event` and emits it to subscribers
    public func accept(_ event: Element) {
        if self.value != event {
            self._relay.accept(event)
        }
    }
    
    /// Current value of behavior subject
    public var value: Element {
        // this try! is ok because subject can't error out or be disposed
        return self._relay.value
    }
    
    /// Initializes behavior relay with initial value.
    public init(value: Element) {
        self._relay = BehaviorRelay(value: value)
    }
    
    /// Subscribes observer
    public func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.Element == Element {
        return self._relay.subscribe(observer)
    }
    
    /// - returns: Canonical interface for push style sequence
    public func asObservable() -> Observable<Element> {
        return self._relay.asObservable()
    }
    
    public func asDriver() -> Driver<Element> {
        return self._relay.asDriver()
    }
}
