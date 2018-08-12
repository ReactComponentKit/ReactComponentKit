//
//  UICollectionViewComponent.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 12..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import SnapKit

import BKRedux
import BKEventBus

import RxSwift
import RxCocoa

class UICollectionViewComponent: UIViewComponent {
    
    private let disposeBag = DisposeBag()
    private(set) var collectionView: UICollectionView
    public init(token: Token, collectionViewLayout: UICollectionViewLayout? = nil) {
        if let collectionViewLayout = collectionViewLayout {
            self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        } else {
            self.collectionView = UICollectionView(frame: .zero)
        }
        super.init(token: token)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
