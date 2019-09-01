//
//  RandomColorAction.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 28..
//  Copyright © 2018년 Burt.K. All rights reserved.
//


import UIKit

struct RandomColorAction: Action {
    private static let colors = [
        UIColor.blue,
        UIColor.yellow,
        UIColor.red,
        UIColor.magenta,
        UIColor.purple,
        UIColor.brown,
        UIColor.lightGray,
        UIColor.white
    ]
    
    let payload: UIColor = RandomColorAction.colors[Int(arc4random()) % RandomColorAction.colors.count]
}
