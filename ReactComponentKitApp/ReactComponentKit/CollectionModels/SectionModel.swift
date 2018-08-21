//
//  SectionModel.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import UIKit

public protocol SectionModel {
    var items: [ItemModel] { get set }
    var itemCount: Int { get }
    
    var header: SectionHeaderModel? { get set }
    var footer: SectionFooterModel? { get set }
    
    var inset: UIEdgeInsets { get }
    var minimumLineSpacing: CGFloat { get }
    var minimumInteritemSpacing: CGFloat { get }
    
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
    
    public var inset: UIEdgeInsets = .zero
    public var minimumLineSpacing: CGFloat = 0
    public var minimumInteritemSpacing: CGFloat  = 0
    
    public required init(items: [ItemModel], header: SectionHeaderModel? = nil, footer: SectionFooterModel? = nil) {
        self.items = items
        self.header = header
        self.footer = footer
    }
}
