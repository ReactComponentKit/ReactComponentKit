//
//  UICollectionViewComponent.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 12..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit

import BKRedux
import BKEventBus

import RxSwift
import RxCocoa

open class UICollectionViewComponent: UIViewComponent {
    
    public enum ViewType {
        case cell
        case header
        case footer
    }
    
    public var adapter: UICollectionViewAdapter? {
        didSet {
            collectionView.delegate = adapter
            collectionView.dataSource = adapter
            collectionView.reloadData()
        }
    }
    
    private let disposeBag = DisposeBag()
    public let collectionView: UICollectionView

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
        let defaultLayout = UICollectionViewFlowLayout()
        defaultLayout.scrollDirection = .vertical
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: defaultLayout)
        super.init(token: token, canOnlyDispatchAction: canOnlyDispatchAction)
    }
    
    open override func setupView() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        collectionView.backgroundColor = .clear
        collectionView.contentInset = .zero
    }
    
    public func register<UIViewComponentType: UIViewComponent>(component: UIViewComponentType.Type, viewType: ViewType = .cell) {
        switch viewType {
        case .cell:
            let cellClass = CollectionViewComponentCell.self
            self.collectionView.register(cellClass, forCellWithReuseIdentifier: String(describing: component))
        case .header:
            let viewClass = CollectionReusableComponentView.self
            self.collectionView.register(viewClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: component))
        case .footer:
            let viewClass = CollectionReusableComponentView.self
            self.collectionView.register(viewClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: component))
        }
        
    }
    
    open func reloadData() {
        self.collectionView.reloadData()
    }
}
