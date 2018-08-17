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
