//
//  RedViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 31..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import BKEventBus

//class RedViewModel: ComponentModel {
//
//}

class RedViewController: UIViewController, ReactComponent {
    
    static func viewController(token: Token) -> UIViewController {
        return RedViewController(token: token)
    }
    
    public lazy var eventBus: EventBus<ComponentEvent> = {
        return EventBus(token: self.token)
    }()
    
    var token: Token
    required init(token: Token) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
        
        eventBus.on { [weak self] (event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .on(state):
                if let newColor = state?["color"] as? UIColor {
                    strongSelf.view.backgroundColor = newColor
                }
            default:
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    var model: ComponentModel?
    
    var contentSize: CGSize {
        return self.view.bounds.size
    }
    
//    func update(with model: RedViewModel) {
//        self.model = model
//    }

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
        //removeFromSuperViewController()
        eventBus.post(event: .dispatch(action: RandomColorAction()))
    }
    
}
