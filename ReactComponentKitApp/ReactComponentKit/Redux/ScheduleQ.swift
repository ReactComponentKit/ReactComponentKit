//
//  ScheduleQ.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019/09/01.
//  Copyright © 2019 Burt.K. All rights reserved.
//

import Foundation
import RxSwift

internal enum Q {
    internal static let serialQ = SerialDispatchQueueScheduler(qos: .background)
    internal static let serialDispatchQ = SerialDispatchQueueScheduler(qos: .background)
    internal static let concurrentQ = ConcurrentDispatchQueueScheduler(qos: .background)
}
