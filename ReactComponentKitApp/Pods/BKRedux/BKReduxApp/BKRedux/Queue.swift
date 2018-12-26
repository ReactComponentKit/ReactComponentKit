//
//  Queue.swift
//  BKReduxApp
//
//  Created by burt on 2018. 12. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
class Queue<T> {
    
    private var items: [T] = []
    
    func enqueue(item: T) {
        items.insert(item, at: 0)
    }
    
    func dequeue() -> T? {
        return items.popLast()
    }
    
    var count: Int {
        return items.count
    }
    
    var isEmpty: Bool {
        return items.isEmpty
    }
}
