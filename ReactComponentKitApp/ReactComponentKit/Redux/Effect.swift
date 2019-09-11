//
//  Effect.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019/09/01.
//  Copyright © 2019 Burt.K. All rights reserved.
//

import Foundation

public typealias Effect<S: State> = (S) -> S
