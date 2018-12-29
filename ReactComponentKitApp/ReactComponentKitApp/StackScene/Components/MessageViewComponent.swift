//
//  MessageViewComponent.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 2..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import BKRedux
import BKEventBus
import SnapKit

class MessageViewComponent: UIViewComponent {
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        return label
    }()
    
    override var contentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: label.intrinsicContentSize.height + 16)
    }
        
    override func setupView() {
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func on(state: State) {
        guard let stackViewState = state as? StackViewState else { return }
        label.text = stackViewState.text
    }
    
    override func configure<Item>(item: Item, at indexPath: IndexPath) {
        guard let todoItem = item as? TodoItem else { return }
        label.text = todoItem.item
    }
}

