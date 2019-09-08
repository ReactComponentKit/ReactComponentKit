//
//  ConsoleLogMiddleware.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import RxSwift

func logAction(action: Action) -> Action {
    print("[## LOGGING ##] action: \(type(of: action).name)")
    return action
}
