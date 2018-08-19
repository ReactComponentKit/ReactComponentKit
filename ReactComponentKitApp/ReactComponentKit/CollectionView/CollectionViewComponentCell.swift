//
//  ComponentCollectionViewCell.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 29..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import SnapKit

internal class CollectionViewComponentCell: UICollectionViewCell {
    
    var rootComponentView: UIViewComponent? {
        didSet {
            guard rootComponentView != nil else { return }
            rootComponentView?.removeFromSuperview()
            installRootComponentView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return rootComponentView?.contentSize ?? .zero
    }
    
    private func installRootComponentView() {
        guard let rootComponentView = rootComponentView else { return }
        self.addSubview(rootComponentView)
        rootComponentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}