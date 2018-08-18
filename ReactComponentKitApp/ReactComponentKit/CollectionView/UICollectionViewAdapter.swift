//
//  UICollectionViewAdapter.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 18..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit

open class UICollectionViewAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak private(set) var collectionViewComponent: UICollectionViewComponent? = nil
    private var sections: [SectionModel] = []
    
    public init(collectionViewComponent: UICollectionViewComponent?) {
        self.collectionViewComponent = collectionViewComponent
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard sections.count > section else { return 0 }
        return sections[section].itemCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemModel = sections[indexPath.section].items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: itemModel.componentClass), for: indexPath)
        
        if let componentCell = cell as? CollectionViewComponentCell {
            if let rootComponentView = componentCell.rootComponentView {
                rootComponentView.applyNew(item: itemModel)
            } else {
                if let token = collectionViewComponent?.token {
                    let component = itemModel.componentClass.init(token: token, canOnlyDispatchAction: true)
                    component.applyNew(item: itemModel)
                    componentCell.rootComponentView = component
                }
            }
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
    
        if kind == UICollectionElementKindSectionHeader {
            guard let header = sections[section].header else { return UICollectionReusableView(frame: .zero) }
            guard let token = collectionViewComponent?.token else { return UICollectionReusableView(frame: .zero) }
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: header.componentClass), for: indexPath)
            if let componentView = view as? CollectionReusableComponentView {
                if let rootComponentView = componentView.rootComponentView {
                    rootComponentView.applyNew(item: header)
                } else {
                    let rootComponentView = header.componentClass.init(token: token, canOnlyDispatchAction: true)
                    rootComponentView.applyNew(item: header)
                    componentView.rootComponentView = rootComponentView
                }
            }
            return view
            
        } else {
            guard let footer = sections[section].footer else { return UICollectionReusableView(frame: .zero) }
            guard let token = collectionViewComponent?.token else { return UICollectionReusableView(frame: .zero) }
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: footer.componentClass), for: indexPath)
            if let componentView = view as? CollectionReusableComponentView {
                if let rootComponentView = componentView.rootComponentView {
                    rootComponentView.applyNew(item: footer)
                } else {
                    let rootComponentView = footer.componentClass.init(token: token, canOnlyDispatchAction: true)
                    rootComponentView.applyNew(item: footer)
                    componentView.rootComponentView = rootComponentView
                }
            }
            return view
        }
    }
    
    
    public func set(section: SectionModel) {
        self.set(sections: [section])
    }
    
    public func set(sections: [SectionModel]) {
        self.sections = sections
        
        // 성능상 너무 안 좋다.
        // diff를 도입하자
        self.collectionViewComponent?.reloadData()
    }
}
