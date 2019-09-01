//
//  ItemModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

public protocol ItemModel: UIViewComponentClassProvider, ContentSizeProvider {
    // HashValue for using diff algorithms.
    var id: Int { get }
}
