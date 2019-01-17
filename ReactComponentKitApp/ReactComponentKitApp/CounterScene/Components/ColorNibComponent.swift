//
//  ColorNibComponent.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019. 1. 18..
//  Copyright © 2019년 Burt.K. All rights reserved.
//

import UIKit
import BKRedux

class ColorNibComponent: UIViewComponent {
    @IBOutlet weak var colorA: UIImageView!
    @IBOutlet weak var colorB: UIImageView!
    @IBOutlet weak var colorC: UIImageView!
    
    override var useNib: Bool {
        return true
    }
        
    override func on(state: State) {
        guard let state = state as? CounterSceneState else { return }
        colorA.backgroundColor = state.color.withAlphaComponent(0.9)
        colorB.backgroundColor = state.color.withAlphaComponent(0.7)
        colorC.backgroundColor = state.color.withAlphaComponent(0.5)
    }
}
