//
//  UICollectionViewAdapter.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 18..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit

open class UICollectionViewAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak private(set) var collectionViewComponent: UICollectionViewComponent? = nil
    private var sections: [SectionModel] = []
    private let useDiff: Bool
    
    public init(collectionViewComponent: UICollectionViewComponent?, useDiff: Bool = false) {
        self.collectionViewComponent = collectionViewComponent
        self.useDiff = useDiff
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard sections.count > section else { return 0 }
        return sections[section].itemCount
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemModel = sections[indexPath.section].items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: itemModel.componentClass), for: indexPath)
        
        if let componentCell = cell as? CollectionViewComponentCell {
            if let rootComponentView = componentCell.rootComponentView {
                rootComponentView.applyNew(item: itemModel, at: indexPath)
            } else {
                if let token = collectionViewComponent?.token {
                    let component = itemModel.componentClass.init(token: token, receiveState: false)
                    component.applyNew(item: itemModel, at: indexPath)
                    componentCell.rootComponentView = component
                }
            }
        }
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
    
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = sections[section].header else { return UICollectionReusableView(frame: .zero) }
            guard let token = collectionViewComponent?.token else { return UICollectionReusableView(frame: .zero) }
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: header.componentClass), for: indexPath)
            if let componentView = view as? CollectionReusableComponentView {
                if let rootComponentView = componentView.rootComponentView {
                    rootComponentView.applyNew(item: header, at: indexPath)
                } else {
                    let rootComponentView = header.componentClass.init(token: token, receiveState: false)
                    rootComponentView.applyNew(item: header, at: indexPath)
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
                    rootComponentView.applyNew(item: footer, at: indexPath)
                } else {
                    let rootComponentView = footer.componentClass.init(token: token, receiveState: false)
                    rootComponentView.applyNew(item: footer, at: indexPath)
                    componentView.rootComponentView = rootComponentView
                }
            }
            return view
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard sections.count > indexPath.section else { return .zero }
        guard sections[indexPath.section].items.count > indexPath.item else { return .zero }
        let itemModel = sections[indexPath.section].items[indexPath.item]
        return itemModel.contentSize
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard sections.count > section else { return .zero }
        guard let header = sections[section].header else { return .zero }
        return header.contentSize
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard sections.count > section else { return .zero }
        guard let footer = sections[section].footer else { return .zero }
        return footer.contentSize
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard sections.count > section else { return .zero }
        let sectionModel = sections[section]
        return sectionModel.inset
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard sections.count > section else { return 0 }
        let sectionModel = sections[section]
        return sectionModel.minimumLineSpacing
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard sections.count > section else { return 0 }
        let sectionModel = sections[section]
        return sectionModel.minimumInteritemSpacing
    }
    
    open func set(section: SectionModel) {
        self.set(sections: [section])
    }
    
    open func set(sections: [SectionModel]) {
        if useDiff == false {
            self.sections = sections
            self.collectionViewComponent?.reloadData()
        } else {
            if self.sections.count != sections.count {
                self.sections = sections
                self.collectionViewComponent?.reloadData()
            } else {
                
                var section: Int = 0
                let oldSections = self.sections
                zip(oldSections, sections).forEach { (oldSection, newSection) in
                    let oldHashable = oldSection.items.map { $0.id }
                    let newHashable = newSection.items.map { $0.id }
                    let changes = diff(old: oldHashable, new: newHashable)
                    if changes.isEmpty == false {
                        self.collectionViewComponent?
                            .collectionView
                            .reload(changes: changes,
                                    section: section,
                                    updateData: {
                                        self.sections[section] = newSection
                                    },
                                    completion: nil)
                    }
                    section += 1
                }
            }
        }
    }
}
