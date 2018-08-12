//
//  TableViewComponent.swift
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

public class UITableViewComponent: UIViewComponent {
    
    private let disposeBag = DisposeBag()
    private(set) var tableView: UITableView
    public init(token: Token, style: UITableViewStyle = .plain) {
        self.tableView = UITableView(frame: .zero, style: style)
        super.init(token: token)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
