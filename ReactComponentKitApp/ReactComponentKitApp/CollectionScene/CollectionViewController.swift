//
//  CollectionViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 19..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import SnapKit
import BKEventBus
import RxSwift
import RxCocoa

class CollectionViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = CollectionViewModel()
    
    private lazy var collectionViewComponent: UICollectionViewComponent = {
        let component = UICollectionViewComponent(token: self.viewModel.token)
        return component
    }()
    
    private lazy var adapter: UICollectionViewAdapter = {
        let adapter = UICollectionViewAdapter(collectionViewComponent: self.collectionViewComponent)
        let section = DefaultSectionModel(items: [])
        adapter.set(section: section)
        return adapter
    }()
    
    private lazy var addTotoItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickedAddTodoButton(sender:)))
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionViewComponent)
        collectionViewComponent.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        setupCollectionViewComponent()
        setupButtons()
        
        viewModel.rx_sections.asDriver()
            .drive(onNext: { [weak self] (sections) in
                guard let strongSelf = self else { return }
                strongSelf.adapter.set(sections: sections)
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func clickedAddTodoButton(sender: UIBarButtonItem) {
        viewModel.rx_action.accept(AddTodoAction())
    }
}

extension CollectionViewController {
    fileprivate func setupCollectionViewComponent() {
        collectionViewComponent.register(component: TodoSectionComponent.self, viewType: .header)
        collectionViewComponent.register(component: TodoSectionComponent.self, viewType: .footer)
        collectionViewComponent.register(component: MessageViewComponent.self)
        collectionViewComponent.adapter = adapter
    }
    
    fileprivate func setupButtons() {
        self.navigationItem.rightBarButtonItem = addTotoItem
    }
}
