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
    public var newStateEventBus: EventBus<ComponentNewStateEvent>? = nil
    public var dispatchEventBus: EventBus<ComponentDispatchEvent>
    
    public var contentSize: CGSize {
        return .zero
    }
    
    override public var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    public required init(token: Token, canOnlyDispatchAction: Bool = false) {
        self.token = token
        dispatchEventBus = EventBus(token: token)
        if canOnlyDispatchAction == false {
            newStateEventBus = EventBus(token: token)
        }
        super.init(frame: .zero)
        self.newStateEventBus?.on { [weak self] (event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .on(state):
                strongSelf.applyNew(state: state)
            }
        }
        
        self.setupView()
        invalidateIntrinsicContentSize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupView() {
        
    }
    
    func applyNew(state: [String:State]?) {
        on(state: state)
        invalidateIntrinsicContentSize()
    }
    
    // UIViewComponent가 UITableViewCell이나 UICollectionViewCell 내부가 아닌
    // 단독 뷰로 사용될 때 상태가 변경되면 호출된다.
    public func on(state: [String:State]?) {
        
    }
    
    func applyNew<Item>(item: Item) {
        configure(item: item)
        invalidateIntrinsicContentSize()
    }
    
    // UIViewComponent가 UITableViewCell이나 UICollectionViewCell 내부에서 쓰이면 이 메서드가 호출된다.
    public func configure<Item>(item: Item) {
    
    }
    
    public func dispatch(action: Action) {
        dispatchEventBus.post(event: .dispatch(action: action))
    }
}
