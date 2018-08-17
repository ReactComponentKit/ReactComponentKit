//
//  TableViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import SnapKit

class TableViewController: UIViewController {
    
    private let viewModel = TableViewModel()
    private lazy var tableViewComponent: UITableViewComponent = {
        let component = UITableViewComponent(token: self.viewModel.token)
        return component
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableViewComponent)
        tableViewComponent.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        setupTableViewComponent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension TableViewController {
    fileprivate func setupTableViewComponent() {
        viewModel.rx_action.accept(AddTodoAction())
    }
}
