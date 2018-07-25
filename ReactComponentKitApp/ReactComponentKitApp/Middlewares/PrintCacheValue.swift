//
//  PrintCacheValue.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

func printCacheValue(state: [String:State], action: Action) -> [String:State] {
    print("[## CACHED ##] value: \(UserDefaults.standard.integer(forKey: "count"))")
    return state
}
