//
//  ComponentView.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 8. 4..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit

open class UIViewComponent: UIView, ReactComponent, ContentSizeProvider {
    
    public var token: Token {
        didSet {
            onChangedToken()
        }
    }
    private weak var nibContentView: UIView? = nil
    public var contentView: UIView {
        return nibContentView ?? self
    }
    
    open var contentSize: CGSize {
        return .zero
    }
    
    override open var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    public required init(token: Token) {
        self.token = token
        super.init(frame: .zero)
        self.setupView()
        invalidateIntrinsicContentSize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.token = Token.empty
        super.init(coder: aDecoder)
        loadNibView()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        invalidateIntrinsicContentSize()
    }
    
    // Used for nib view component
    public func reset(token: Token) {
        guard token != Token.empty else { return }
        self.token = token
    }
    
    private func loadNibView() {
        let nib = UINib(nibName: self.classNameString, bundle: Bundle(for: type(of: self)))
        let rootView = nib.instantiate(withOwner: self, options: nil).first { (obj) -> Bool in
            return obj is UIView
        }
        guard let v = rootView as? UIView else { return }
        addSubview(v)
        nibContentView = v
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            v.topAnchor.constraint(equalTo: self.topAnchor),
            v.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
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
    
    open func onChangedToken() {
        
    }
    
    // Override it to configure or update views
    open func on(state: State) {
        
    }
    
    // It is only called when the component is in UITableView's cell or UICollectionView's cell
    func applyNew<Item>(item: Item, at indexPath: IndexPath) {
        configure(item: item, at: indexPath)
        invalidateIntrinsicContentSize()
    }
    
    // Override it to configure or update views
    open func configure<Item>(item: Item, at indexPath: IndexPath) {
    
    }    
}

extension NSObject {
    @objc fileprivate class var classNameString: String {
        let cname = NSStringFromClass(self)
        if cname.contains(".") {
            let components = cname.components(separatedBy: ".")
            if let last = components.last {
                return last
            }
        }
        return cname
    }
    
    @objc fileprivate var classNameString: String {
        return type(of: self).classNameString
    }
}
