//
//  Component.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 31..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import UIKit
import BKEventBus
import BKRedux

public enum ComponentEvent: EventType {
    case on(state: [String:State]?)
    case dispatch(action: Action)
}

// 이벤트를 들을 수 있는 컴포넌트
public protocol Component {
    var token: Token { get set }
    var eventBus: EventBus<ComponentEvent> { get }
}

// 컴포넌트 컨텐츠 Size 프로바이더
public protocol ContentSizeProvider {
    var contentSize: CGSize { get }
}
