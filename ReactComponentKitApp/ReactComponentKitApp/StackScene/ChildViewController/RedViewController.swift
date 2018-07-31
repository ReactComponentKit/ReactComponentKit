//
//  RedViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 31..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit

class RedViewModel: ComponentModel {
    
}

class RedViewController: UIViewController, Component {
    
    var model: ComponentModel?
    
    var contentSize: CGSize? {
        return self.view.bounds.size
    }
    
    func update(with model: RedViewModel) {
        self.model = model
    }

    static func viewController() -> UIViewController {
        return RedViewController(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeFromSuperViewController()
    }
    
}
