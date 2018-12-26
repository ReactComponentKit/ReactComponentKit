//
//  StackViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 31..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import SnapKit

class StackViewController: UIViewController {
    
    private var childVC: UIViewController? = nil
    private let viewModel = StackViewModel()
    private lazy var messageViewComponent: MessageViewComponent = {
        return MessageViewComponent(token: self.viewModel.token)
    }()
    
    private lazy var buttonComponent: ButtonComponent = {
        return ButtonComponent(token: self.viewModel.token)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //childVC = add(viewController: RedViewController.viewController(token: viewModel.token))
        self.view.addSubview(messageViewComponent)
        self.view.addSubview(buttonComponent)
        
        messageViewComponent.backgroundColor = UIColor.red
        messageViewComponent.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview()
        }
        
        buttonComponent.snp.makeConstraints { (make) in
            make.top.equalTo(messageViewComponent.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(48)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func clickedAddButton(_ sender: Any) {
        //childVC = add(viewController: RedViewController.viewController(token: viewModel.token))
        self.viewModel.dispatch(action: TextAction())
    }
    
}
