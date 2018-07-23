//
//  Token.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//
//  EventBus를 사용해 Store와 액션을 주고 받을 때, 타켓을 구분하는 용도로 사용한다.
import Foundation

struct Token: Equatable {
    private let token: String
    init() {
        token = UUID().uuidString
    }
}
