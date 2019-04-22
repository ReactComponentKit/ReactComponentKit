//
//  ColorNibComponent.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019. 1. 18..
//  Copyright © 2019년 Burt.K. All rights reserved.
//

import UIKit
import BKRedux

protocol ColorNibComponentState {
    var color: UIColor { get }
}

class ColorNibComponent: UIViewComponent {
    @IBOutlet weak var colorA: UIImageView!
    @IBOutlet weak var colorB: UIImageView!
    @IBOutlet weak var colorC: UIImageView!
            
    override func on(state: State) {
        guard let componentState = state as? ColorNibComponentState else { return }
        colorA.backgroundColor = componentState.color.withAlphaComponent(0.9)
        colorB.backgroundColor = componentState.color.withAlphaComponent(0.7)
        colorC.backgroundColor = componentState.color.withAlphaComponent(0.5)
    }
}
