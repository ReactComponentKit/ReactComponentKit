//
//  StateKeyPath.swift
//  BKReduxApp
//
//  Created by burt on 2018. 9. 22..
//  Copyright © 2018년 Burt.K. All rights reserved.
//
//  @see { https://stackoverflow.com/questions/47764795/in-swift-4-how-can-you-assign-to-a-keypath-when-the-type-of-the-keypath-and-val }
//

import Foundation

public struct StateKeyPath<S: State>: Hashable {
    
    private let applicator: (Any?, S) -> S
    private let id: Int
    
    public let anyKeyPath: AnyKeyPath
    public init<ValueType>(_ keyPath: WritableKeyPath<S, ValueType>) {
        id = UUID().hashValue
        anyKeyPath = keyPath
        applicator = {
            var instance = $1
            if let value = $0 as? ValueType {
                instance[keyPath: keyPath] = value
            }
            return instance
        }
    }
    
    public func apply(value: Any?, to state: S) -> S {
        return applicator(value, state)
    }
    
    public var hashValue: Int {
        return id
    }
    
    public static func == (lhs: StateKeyPath<S>, rhs: StateKeyPath<S>) -> Bool {
        return lhs.id == rhs.id
    }
}
