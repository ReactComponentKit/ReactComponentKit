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
        return label.intrinsicContentSize
    }
        
    override func setupView() {
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func on(state: [String:State]?) {
        guard let text = state?["text"] as? String else { return }
        label.text = text
    }
}

