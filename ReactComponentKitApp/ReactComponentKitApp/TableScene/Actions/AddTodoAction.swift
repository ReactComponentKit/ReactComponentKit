//
//  AddTodoAction.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

struct AddTodoAction: Action {
    let payload = "  Todo : \(Date().description)"
}
