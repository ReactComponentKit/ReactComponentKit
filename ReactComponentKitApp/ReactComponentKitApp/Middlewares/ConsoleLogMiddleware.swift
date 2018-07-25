//
//  ConsoleLogMiddleware.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

func consoleLogMiddleware(state: [String:State], action: Action) -> [String:State] {
    print("[## LOGGING ##] action: \(String(describing: action)) :: state: \(state)")
    return state
}
