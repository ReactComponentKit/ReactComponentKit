//
//  SectionHeaderComponent.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import SnapKit

class TodoSectionComponent: UIViewComponent {
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 8)
        return label
    }()
    
    override var contentSize: CGSize {
        return CGSize(width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height + 8)
    }
    
    override func setupView() {
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.backgroundColor = UIColor.brown
    }
        
    override func configure<Item>(item: Item, at indexPath: IndexPath) {
        if let sectionHeader = item as? TodoSectionHeaderModel {
            label.text = sectionHeader.title
        } else if let sectionFooter = item as? TodoSectionFooterModel {
            label.text = sectionFooter.title
        }
    }
}
