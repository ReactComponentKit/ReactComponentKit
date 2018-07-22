//
//  ColorBox.swift
//  ReactComponentKit
//
//  Created by burt on 2018. 7. 21..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import SnapKit

class ColorBox: Component<ColorBox.State> {
    struct State: StateType {
        let color: UIColor
    }
    
    override func configure(state: ColorBox.State) {
        super.configure(state: state)
        self.backgroundColor = state.color
    }
    
    override func render(state: ColorBox.State) {
        self.backgroundColor = state.color
    }
    
    override func layout(withinContainer container: UIView) {
        snp.makeConstraints { (make) in
            make.left.right.equalTo(100)
            make.width.height.equalTo(100)
        }
    }
}
