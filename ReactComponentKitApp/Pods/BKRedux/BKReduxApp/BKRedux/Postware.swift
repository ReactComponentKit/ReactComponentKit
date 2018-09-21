//
//  Postware.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift

public typealias Postware = (State, Action) -> Observable<State>
