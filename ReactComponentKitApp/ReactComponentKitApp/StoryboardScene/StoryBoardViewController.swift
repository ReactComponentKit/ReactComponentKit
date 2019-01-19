//
//  StoryBoardViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2019. 1. 20..
//  Copyright © 2019년 Burt.K. All rights reserved.
//

import UIKit

class StoryBoardViewController: UIViewController {
    
    private let viewModel = StoryBoardViewModel()
    
    private lazy var loadingComponent: UIViewControllerComponent = {
        return LoadingComponent.viewControllerComponent()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingComponent.reset(token: viewModel.token, receiveState: false)
        
        add(viewController: loadingComponent)
    }

}
