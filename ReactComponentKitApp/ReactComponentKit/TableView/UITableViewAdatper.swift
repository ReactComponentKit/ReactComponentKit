//
//  TableViewAdatper.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit

open class UITableViewApater: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak private(set) var tableViewComponent: UITableViewComponent? = nil
    private var sections: [SectionModel] = []
    private var sectionHeaderInfo: [Int:UIViewComponent] = [:]
    private var sectionFooterInfo: [Int:UIViewComponent] = [:]
    private let useDiff: Bool
    
    public init(tableViewComponent: UITableViewComponent?, useDiff: Bool = false) {
        self.tableViewComponent = tableViewComponent
        self.useDiff = useDiff
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.count > section else { return 0 }
        return sections[section].itemCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemModel = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: itemModel.componentClass), for: indexPath)
    
        if let componentCell = cell as? TableViewComponentCell {
            if let rootComponentView = componentCell.rootComponentView {
                rootComponentView.applyNew(item: itemModel)
            } else {
                if let token = tableViewComponent?.token {
                    let component = itemModel.componentClass.init(token: token, canOnlyDispatchAction: true)
                    component.applyNew(item: itemModel)
                    componentCell.rootComponentView = component
                }
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let existHeader = sectionHeaderInfo[section] {
            return existHeader
        }
        
        guard let header = sections[section].header else { return nil }
        guard let token = tableViewComponent?.token else { return nil }
        let sectionHeaderView = header.componentClass.init(token: token, canOnlyDispatchAction: true)
        sectionHeaderView.applyNew(item: header)
        sectionHeaderInfo[section] = sectionHeaderView
        return sectionHeaderView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let existHeader = sectionHeaderInfo[section] {
            return existHeader.contentSize.height
        }
        
        guard let header = sections[section].header else { return 0 }
        guard let token = tableViewComponent?.token else { return 0 }
        let sectionHeaderView = header.componentClass.init(token: token, canOnlyDispatchAction: true)
        sectionHeaderView.applyNew(item: header)
        sectionHeaderInfo[section] = sectionHeaderView
        return sectionHeaderView.contentSize.height
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let existFooter = sectionFooterInfo[section] {
            return existFooter
        }
        
        guard let footer = sections[section].footer else { return nil }
        guard let token = tableViewComponent?.token else { return nil }
        let sectionFooterView = footer.componentClass.init(token: token, canOnlyDispatchAction: true)
        sectionFooterView.applyNew(item: footer)
        sectionFooterInfo[section] = sectionFooterView
        return sectionFooterView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let existFooter = sectionFooterInfo[section] {
            return existFooter.contentSize.height
        }
        
        guard let footer = sections[section].footer else { return 0 }
        guard let token = tableViewComponent?.token else { return 0 }
        let sectionFooterView = footer.componentClass.init(token: token, canOnlyDispatchAction: true)
        sectionFooterView.applyNew(item: footer)
        sectionFooterInfo[section] = sectionFooterView
        return sectionFooterView.contentSize.height
    }
    
    public func set(section: SectionModel) {
        self.set(sections: [section])
    }
    
    public func set(sections: [SectionModel]) {
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
                    self.sections[section] = newSection
                    self.tableViewComponent?.tableView.reload(changes: changes,
                                                              section: section,
                                                              insertionAnimation: UITableViewRowAnimation.none,
                                                              deletionAnimation: UITableViewRowAnimation.none,
                                                              replacementAnimation: UITableViewRowAnimation.none,
                                                              completion: nil)
                    section += 1
                }
            }
        }
    }
}
