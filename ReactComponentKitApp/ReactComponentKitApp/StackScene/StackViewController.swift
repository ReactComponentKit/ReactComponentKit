//
//  StackViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 31..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {
    
    private var childVC: UIViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        childVC = add(viewController: RedViewController.viewController())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func clickedAddButton(_ sender: Any) {
        childVC = add(viewController: RedViewController.viewController())
    }
    
}
