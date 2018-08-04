//
//  ComponentView.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 4..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import BKEventBus
import BKRedux

public class UIViewComponent: UIView, Component, ContentSizeProvider {
    
    public var token: Token
    public var eventBus: EventBus<ComponentEvent>
    
    public var contentSize: CGSize {
        return .zero
    }
    
    override public var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    public init(token: Token) {
        self.token = token
        self.eventBus = EventBus(token: token)
        super.init(frame: .zero)
        
        self.eventBus.on { [weak self] (event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .on(state):
                strongSelf.applyNew(state: state)
            default:
                break
            }
        }
        
        self.setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
    }
    
    private func applyNew(state: [String:State]?) {
        on(state: state)
        invalidateIntrinsicContentSize()
    }
    
    func on(state: [String:State]?) {
        
    }
    
    func dispatch(action: Action) {
        eventBus.post(event: .dispatch(action: action))
    }
}
