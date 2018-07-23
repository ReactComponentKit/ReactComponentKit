//
//  EventBus.swift
//  EventBusApp
//
//  Created by burt on 2018. 2. 27..
//  Copyright © 2018년 skyfe79. All rights reserved.
//

import UIKit

// Mark as Event
public protocol EventType {
    
}

public class EventBus<T: EventType> {
    
    private typealias EventHandler = (T) -> Void
    private var eventHandler: EventHandler? = nil
    private var isAlive: Bool = true
    private lazy var eventName: Notification.Name = {
        let eventTypeName = String(describing: T.self)
        return Notification.Name("NOTIFY_EVENTBUS_POST_\(eventTypeName)_EVENT")
    }()
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification(_:)), name: eventName, object: nil)
    }
    
    @objc private func processNotification(_ notificaton: Notification) {
        // ignore events if didn't alive
        guard isAlive == true else { return }
        // ignore notification if same eventbus.
        guard let sender = notificaton.object as? EventBus<T>, sender !== self else { return }
        guard let userInfo = notificaton.userInfo else { return }
        guard let event = userInfo["event"] as? T else { return }
        handle(event: event)
    }
    
    public func post(event: T) {
        NotificationCenter.default.post(name: eventName, object: self, userInfo: [
            "event": event
        ])
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
