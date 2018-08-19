//
//  TodoItem.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import BKEventBus

struct TodoItem: ItemModel {
    var componentClass: UIViewComponent.Type {
        return MessageViewComponent.self
    }
    
    var item: String
    
    init(item: String) {
        self.item = item
    }
    
    var contentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
}
