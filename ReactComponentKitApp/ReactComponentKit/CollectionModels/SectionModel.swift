//
//  SectionModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

public protocol SectionModel {
    var items: [ItemModel] { get set }
    var itemCount: Int { get }
    
    var header: SectionHeaderModel? { get set }
    var footer: SectionFooterModel? { get set }
    
    init(items: [ItemModel], header: SectionHeaderModel?, footer: SectionFooterModel?)
}

extension SectionModel {
    public var itemCount: Int {
        return items.count
    }
}

public class DefaultSectionModel: SectionModel {
    public var items: [ItemModel]
    
    public var header: SectionHeaderModel?
    public var footer: SectionFooterModel?
    
    public required init(items: [ItemModel], header: SectionHeaderModel? = nil, footer: SectionFooterModel? = nil) {
        self.items = items
        self.header = header
        self.footer = footer
    }
}
