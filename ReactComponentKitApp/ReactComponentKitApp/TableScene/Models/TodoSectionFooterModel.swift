//
//  TodoSectionFooterModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

struct TodoSectionFooterModel: SectionFooterModel {
    var componentClass: UIViewComponent.Type {
        return TodoSectionComponent.self
    }
    
    let title: String
    
    init(title: String) {
        self.title = title
    }
}

