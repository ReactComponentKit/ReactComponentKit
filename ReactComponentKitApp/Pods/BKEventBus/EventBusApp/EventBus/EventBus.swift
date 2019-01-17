//
//  EventBus.swift
//  EventBusApp
//
//  Created by burt on 2018. 2. 27..
//  Copyright © 2018년 skyfe79. All rights reserved.
//

import Foundation

// Token for targeting
public struct Token: Equatable {
    private let token: String
    public init() {
        self.init(value: UUID().uuidString)
    }
    private init(value: String) {
        token = value
    }
    public static let empty = Token(value: "")
}

// Mark as Event
public protocol EventType {
    
}

public class EventBus<T: EventType> {
    
    private typealias EventHandler = (T) -> Void
    private var eventHandler: EventHandler? = nil
    private var isAlive: Bool = true
    private let token: Token?
    private lazy var eventName: Notification.Name = {
        let eventTypeName = String(describing: T.self)
        return Notification.Name("NOTIFY_EVENTBUS_POST_\(eventTypeName)_EVENT")
    }()
    
    /**
     * @param: token - broadcast if token is nil.
     */
    public init(token: Token? = nil) {
        self.token = token
        if let token = token, token == Token.empty {
            // ignore empty token
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(processNotification(_:)), name: eventName, object: nil)
        }
    }
    
    @objc private func processNotification(_ notificaton: Notification) {
        // ignore events if didn't alive
        guard isAlive == true else { return }
        // ignore notification if same eventbus.
        guard let sender = notificaton.object as? EventBus<T>, sender !== self else { return }
        guard let userInfo = notificaton.userInfo else { return }
        guard let event = userInfo["event"] as? T else { return }
        if let token = userInfo["token"] as? Token {
            if token == self.token {
                handle(event: event)
            }
        } else {
            // broadcast if token is nil
            handle(event: event)
        }
    }
    
    public func post(event: T) {
        var userInfo: [String:Any] = ["event": event]
        if let token = token {
            userInfo["token"] = token
        }
        NotificationCenter.default.post(name: eventName, object: self, userInfo: userInfo)
    }
    
    private func handle(event: T) {
        guard let eventHandler = eventHandler else { return }
        eventHandler(event)
    }
    
    public func on(event: @escaping (T) -> Void) {
        eventHandler = event
    }
    
    public func resume() {
        isAlive = true
    }
    
    public func stop() {
        isAlive = false
    }
    
    deinit {
        eventHandler = nil
        NotificationCenter.default.removeObserver(self, name: eventName, object: nil)
    }
}
