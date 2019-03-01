//
//  TableViewAdatper.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit

open class UITableViewAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak private(set) var tableViewComponent: UITableViewComponent? = nil
    private var sections: [SectionModel] = []
    private var sectionHeaderInfo: [Int:UIViewComponent] = [:]
    private var sectionFooterInfo: [Int:UIViewComponent] = [:]
    private let useDiff: Bool
    private let useComponentContentSize: Bool // using UIViewComponent's contentSize or ItemModel's contentSize
    public init(tableViewComponent: UITableViewComponent?, useDiff: Bool = false, useComponentContentSize: Bool = true) {
        self.tableViewComponent = tableViewComponent
        self.useDiff = useDiff
        self.useComponentContentSize = useComponentContentSize
        if useComponentContentSize {
            tableViewComponent?.tableView.estimatedRowHeight = 40
        }
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.count > section else { return 0 }
        return sections[section].itemCount
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemModel = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: itemModel.componentClass), for: indexPath)
    
        if let componentCell = cell as? TableViewComponentCell {
            if let rootComponentView = componentCell.rootComponentView {
                rootComponentView.applyNew(item: itemModel, at: indexPath)
            } else {
                if let token = tableViewComponent?.token {
                    let component = itemModel.componentClass.init(token: token, receiveState: false)
                    component.applyNew(item: itemModel, at: indexPath)
                    componentCell.rootComponentView = component
                }
            }
        }
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let existHeader = sectionHeaderInfo[section] {
            return existHeader
        }
        
        guard let header = sections[section].header else { return nil }
        guard let token = tableViewComponent?.token else { return nil }
        let sectionHeaderView = header.componentClass.init(token: token, receiveState: false)
        sectionHeaderView.applyNew(item: header, at: IndexPath(row: 0, section: section))
        sectionHeaderInfo[section] = sectionHeaderView
        return sectionHeaderView
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if useComponentContentSize {
            if let existHeader = sectionHeaderInfo[section] {
                return existHeader.contentSize.height
            }
            
            guard let header = sections[section].header else { return 0 }
            guard let token = tableViewComponent?.token else { return 0 }
            let sectionHeaderView = header.componentClass.init(token: token, receiveState: false)
            sectionHeaderView.applyNew(item: header, at: IndexPath(row: 0, section: section))
            sectionHeaderInfo[section] = sectionHeaderView
            return sectionHeaderView.contentSize.height
        }
        
        guard let header = sections[section].header else { return 0 }
        return header.contentSize.height
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let existFooter = sectionFooterInfo[section] {
            return existFooter
        }
        
        guard let footer = sections[section].footer else { return nil }
        guard let token = tableViewComponent?.token else { return nil }
        let sectionFooterView = footer.componentClass.init(token: token, receiveState: false)
        sectionFooterView.applyNew(item: footer, at: IndexPath(row: 0, section: section))
        sectionFooterInfo[section] = sectionFooterView
        return sectionFooterView
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if useComponentContentSize {
            if let existFooter = sectionFooterInfo[section] {
                return existFooter.contentSize.height
            }
            
            guard let footer = sections[section].footer else { return 0 }
            guard let token = tableViewComponent?.token else { return 0 }
            let sectionFooterView = footer.componentClass.init(token: token, receiveState: false)
            sectionFooterView.applyNew(item: footer, at: IndexPath(row: 0, section: section))
            sectionFooterInfo[section] = sectionFooterView
            return sectionFooterView.contentSize.height
        }
        guard let footer = sections[section].footer else { return 0 }
        return footer.contentSize.height
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if useComponentContentSize {
            return UITableView.automaticDimension
        }
        
        guard sections.count > indexPath.section else { return 0 }
        guard sections[indexPath.section].items.count > indexPath.row else { return 0 }
        let item = sections[indexPath.section].items[indexPath.row]
        return item.contentSize.height
    }
        
    open func set(section: SectionModel) {
        self.set(sections: [section])
    }
    
    open func set(sections: [SectionModel], with animation: UITableView.RowAnimation = UITableView.RowAnimation.none) {
        self.set(sections: sections, insertionAnimation: animation, deletionAnimation: animation, replacementAnimation: animation)
    }
    
    open func set(sections: [SectionModel],
                  insertionAnimation: UITableView.RowAnimation,
                  deletionAnimation: UITableView.RowAnimation,
                  replacementAnimation: UITableView.RowAnimation) {
        if useDiff == false {
            self.sections = sections
            self.tableViewComponent?.reloadData()
        } else {
            if self.sections.count != sections.count {
                self.sections = sections
                self.tableViewComponent?.reloadData()
            } else {
                var section: Int = 0
                let oldSections = self.sections
                zip(oldSections, sections).forEach { (oldSection, newSection) in
                    let oldHashable = oldSection.items.map { $0.id }
                    let newHashable = newSection.items.map { $0.id }
                    let changes = diff(old: oldHashable, new: newHashable)
                    
                    self.tableViewComponent?
                        .tableView
                        .reload(changes: changes,
                                section: section,
                                insertionAnimation: insertionAnimation,
                                deletionAnimation: deletionAnimation,
                                replacementAnimation: replacementAnimation,
                                updateData: {
                                    self.sections[section] = newSection
                        }, completion: nil)
                    section += 1
                }
            }
        }
    }
}
