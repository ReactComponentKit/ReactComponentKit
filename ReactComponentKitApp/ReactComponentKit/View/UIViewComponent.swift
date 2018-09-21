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

open class UIViewComponent: UIView, ReactComponent, ContentSizeProvider {

    public var token: Token
    public var newStateEventBus: EventBus<ComponentNewStateEvent>? = nil
    public var dispatchEventBus: EventBus<ComponentDispatchEvent>
    
    open var contentSize: CGSize {
        return .zero
    }
    
    override open var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    public required init(token: Token, canOnlyDispatchAction: Bool = false) {
        self.token = token
        self.dispatchEventBus = EventBus(token: token)
        if canOnlyDispatchAction == false {
            self.newStateEventBus = EventBus(token: token)
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
    
    // Override it to layout sub views.
    open func setupView() {
        
    }
    
    // It is only called when the component is in UITableView's cell or UICollectionView's cell.
    open func prepareForReuse() {
        
    }
    
    // It is called when the component is standalone.
    func applyNew(state: State) {
        on(state: state)
        invalidateIntrinsicContentSize()
    }
    
    // Override it to configure or update views
    open func on(state: State) {
        
    }
    
    // It is only called when the component is in UITableView's cell or UICollectionView's cell
    func applyNew<Item>(item: Item) {
        configure(item: item)
        invalidateIntrinsicContentSize()
    }
    
    // Override it to configure or update views
    open func configure<Item>(item: Item) {
    
    }
    
    // Use it to dispatch actions
    public func dispatch(action: Action) {
        dispatchEventBus.post(event: .dispatch(action: action))
    }
}
