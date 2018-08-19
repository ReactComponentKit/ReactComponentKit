//
//  TodoSectionHeader.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit

struct TodoSectionHeaderModel: SectionHeaderModel {
    var componentClass: UIViewComponent.Type {
        return TodoSectionComponent.self
    }
    
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var contentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
}
