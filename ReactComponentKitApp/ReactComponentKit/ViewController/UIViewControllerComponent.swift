//
//  ComponentUIViewController.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 4..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit

open class UIViewControllerComponent: UIViewController, ReactComponent {
        
    public var token: Token {
        didSet {
            onChangedToken()
        }
    }
        
    
    public static func viewControllerComponent(identifier: String, storyboard: UIStoryboard) -> UIViewControllerComponent {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! UIViewControllerComponent
    }
        
    public required init(token: Token) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.token = Token.empty
        super.init(coder: aDecoder)
    }
    
    // Used for nib view controller
    public func reset(token: Token) {
        guard token != Token.empty else { return }
        self.token = token
    }
    
    open func onChangedToken() {
    }
    
    private func applyNew(state: State) {
        on(state: state)
    }
    
    open func on(state: State) {
        
    }    
}
