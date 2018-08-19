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

public enum ComponentNewStateEvent: EventType {
    case on(state: [String:State]?)
}

public enum ComponentDispatchEvent: EventType {
    case dispatch(action: Action)
}

// 이벤트를 들을 수 있는 컴포넌트
public protocol Component {
    var token: Token { get set }
    // 상태를 받고자 하는 컴포넌트만 받는다.
    // 테이블셀뷰나 컬렉션셀뷰에 포함되는 컴포넌트는 성능상 newState를 받지 않는다.(모든 셀이 새로운 상태를 받으면 상태 복사가 많이 발생하기 때문이다)
    var newStateEventBus: EventBus<ComponentNewStateEvent>? { get }
    // 액션 디스패치는 항상 있어야 한다.
    var dispatchEventBus: EventBus<ComponentDispatchEvent> { get }
    init(token: Token, canOnlyDispatchAction: Bool)
}

// 컴포넌트 컨텐츠 Size 프로바이더
public protocol ContentSizeProvider {
    var contentSize: CGSize { get }
}
