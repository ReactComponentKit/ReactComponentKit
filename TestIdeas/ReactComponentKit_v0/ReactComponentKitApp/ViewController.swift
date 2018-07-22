//
//  ViewController.swift
//  ReactComponentKit
//
//  Created by burt on 2018. 7. 21..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let colorBox = ColorBox(frame: .zero)
        colorBox.configure(state: ColorBox.State(color: UIColor.blue))
        
        self.view.add(component: colorBox)
        
        let actionButton = ActionButton(frame: .zero)
        actionButton.configure(state: ActionButton.State(title: "눌러주세요"))
        self.view.add(component: actionButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

