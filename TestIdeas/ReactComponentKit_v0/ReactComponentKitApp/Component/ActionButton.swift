//
//  ActionButton.swift
//  ReactComponentKit
//
//  Created by burt on 2018. 7. 21..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ActionButton: Component<ActionButton.State> {
    
    struct State: StateType {
        let title: String
        let titleColor: UIColor = UIColor.black
    }
    
    enum Action: ActionType {
        case changeColor(color: UIColor)
    }

    private lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()
    
    private lazy var button: UIButton = {
        return UIButton(type: .system)
    }()
    
    override func configure(state: ActionButton.State) {
        super.configure(state: state)
        button.setTitle(state.title, for: [])
        button.setTitleColor(state.titleColor, for: [])
        button.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dispatch(action: Action.changeColor(color: .red))
        }).disposed(by: self.disposeBag)
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func render(state: ActionButton.State) {
        button.setTitle(state.title, for: [])
        button.setTitleColor(state.titleColor, for: [])
    }
    
    override func layout(withinContainer container: UIView) {
        
        self.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalToSuperview()
        }
    }
}
