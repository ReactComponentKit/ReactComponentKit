//
//  CachePostware.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

func cachePostware(state: [String:State], action: Action) -> [String:State] {
    
    if let count = state["count"] as? Int {
        UserDefaults.standard.set(count, forKey: "count")
        UserDefaults.standard.synchronize()
    }
    
    return state
}
