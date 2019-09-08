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
    private let semaphore = DispatchSemaphore(value: 1) // Allow only one thread.
    
    func peek() -> T? {
        semaphore.wait()
        defer {
            semaphore.signal()
        }
        return items.last
    }
    
    func enqueue(item: T) {
        semaphore.wait()
        defer {
            semaphore.signal()
        }
        items.insert(item, at: 0)
    }
    
    func dequeue() -> T? {
        semaphore.wait()
        defer {
            semaphore.signal()
        }
        return items.popLast()
    }
    
    func clear() {
        semaphore.wait()
        defer {
            semaphore.signal()
        }
        items.removeAll()
        items = []
    }
    
    var count: Int {
        semaphore.wait()
        defer {
            semaphore.signal()
        }
        return items.count
    }
    
    var isEmpty: Bool {
        semaphore.wait()
        defer {
            semaphore.signal()
        }
        return items.isEmpty
    }
    
    var isNotEmpty: Bool {
        semaphore.wait()
        defer {
            semaphore.signal()
        }
        return !items.isEmpty
    }
}
