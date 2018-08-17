//
//  ConsoleLogPostware.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import BKRedux

func consoleLogPostware(state: [String:State], action: Action) -> [String:State] {
    print("[## LOGGING ##] action: \(String(describing: action)) :: state: \(state)")
    return state
}
