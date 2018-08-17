//
//  TableViewAdatper.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit

class UITableViewApater: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    weak var tableViewComponent: UITableViewComponent? = nil
    private var sections: [SectionModel] = []
    private var sectionHeaderInfo: [Int:UIViewComponent] = [:]
    private var sectionFooterInfo: [Int:UIViewComponent] = [:]
    
    init(tableViewComponent: UITableViewComponent?) {
        self.tableViewComponent = tableViewComponent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.count > section else { return 0 }
        return sections[section].itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
    
    func set(section: SectionModel) {
        self.set(sections: [section])
    }
    
    func set(sections: [SectionModel]) {
        self.sections = sections
        
        // 성능상 너무 안 좋다.
        // diff를 도입하자
        self.tableViewComponent?.tableView.reloadData()
    }
}
