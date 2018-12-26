//
//  TableViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 17..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import SnapKit
import BKEventBus
import RxSwift
import RxCocoa

class TableViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = TableViewModel()
    private lazy var tableViewComponent: UITableViewComponent = {
        let component = UITableViewComponent(token: self.viewModel.token)
        return component
    }()
    
    private lazy var adapter: UITableViewAdapter = {
        let adapter = UITableViewAdapter(tableViewComponent: tableViewComponent, useDiff: true)
        let section = DefaultSectionModel(items: [])
        adapter.set(section: section)
        return adapter
    }()
    
    private lazy var addTotoItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickedAddTodoButton(sender:)))
        return item
    }()
    
    private lazy var header: UIViewComponent = {
        let component = ButtonComponent(token: viewModel.token)
        component.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        return component
    }()
    
    private lazy var footer: UIViewComponent = {
        let component = ButtonComponent(token: viewModel.token)
        component.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        return component
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableViewComponent)
        tableViewComponent.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        setupTableViewComponent()
        setupButtons()
        
        viewModel.rx_sections.asDriver()
            .drive(onNext: { [weak self] (sections) in
                guard let strongSelf = self else { return }
                strongSelf.adapter.set(sections: sections, with: .fade)
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func clickedAddTodoButton(sender: UIBarButtonItem) {
        viewModel.dispatch(action: AddTodoAction())
    }
    
}

extension TableViewController {
    fileprivate func setupTableViewComponent() {
        tableViewComponent.headerComponent = header
        tableViewComponent.footerComponent = footer
        tableViewComponent.register(component: MessageViewComponent.self)
        tableViewComponent.adapter = adapter
    }
    
    fileprivate func setupButtons() {
        self.navigationItem.rightBarButtonItem = addTotoItem
    }
}
