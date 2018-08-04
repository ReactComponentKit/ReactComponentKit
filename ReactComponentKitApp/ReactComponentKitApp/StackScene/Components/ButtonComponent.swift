//
//  ButtonComponent.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 4..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import SnapKit

import BKRedux
import BKEventBus

import RxSwift
import RxCocoa

class ButtonComponent: UIViewComponent {
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("액션", for: [])
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    override func setupView() {
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        button.rx.tap.map { TextAction() }.bind(onNext: dispatch).disposed(by: disposeBag)
    }
    
}
