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

    public var collectionViewLayout: UICollectionViewLayout {
        get {
            return collectionView.collectionViewLayout
        }
        
        set {
            collectionView.collectionViewLayout = newValue
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init(token: Token, canOnlyDispatchAction: Bool = true) {
        self.collectionView = UICollectionView(frame: .zero)
        super.init(token: token, canOnlyDispatchAction: canOnlyDispatchAction)
    }
    
    override func setupView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
