//
//  ViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 23..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var colorNibComponent: ColorNibComponent!
    
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorNibComponent.reset(token: viewModel.token)
        plusButton.rx.tap.map { IncreaseAction() }.bind(onNext: viewModel.dispatch).disposed(by: disposeBag)
        minusButton.rx.tap.map { DecreaseAction() }.bind(onNext: viewModel.dispatch).disposed(by: disposeBag)
        colorButton.rx.tap.map { RandomColorAction() }.bind(onNext: viewModel.dispatch).disposed(by: disposeBag)

        viewModel
            .color
            .asDriver()
            .drive(onNext: { [weak self] (color) in
                if self?.view.backgroundColor != color {
                    self?.view.backgroundColor = color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .count
            .asDriver()
            .drive(onNext: { [weak self] (countString) in
                self?.countLabel.text = countString
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
}

