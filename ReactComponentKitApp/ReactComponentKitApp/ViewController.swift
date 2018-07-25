//
//  ViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import BKEventBus

class ViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    
    // STORE
    let store = Store(
        state: [
            "count": 0
        ],
        reducers: [
            "count": countReducer
        ],
        middlewares: [
            printCacheValue,
            consoleLogMiddleware
        ],
        postwares: [
            cachePostware
        ]
    )
    
    lazy var eventBus: EventBus<Store.Event> = {
        return EventBus(token: store.token)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventBus.on { [weak self] (event: Store.Event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .on(newState):
                guard let value = newState["count"] as? Int else { return }
                strongSelf.countLabel.text = String(value)
            default:
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func clickedDecreaseButton(_ sender: Any) {
        store.dispatch(action: DecreaseAction())
    }
    
    
    @IBAction func clickedIncreaseButton(_ sender: Any) {
        store.dispatch(action: IncreaseAction())
    }
    
    
}

