//
//  ChecklistItemHeaderView.swift
//  Checklist
//
//  Created by Celiña Hiyas Javier on 17/05/2019.
//  Copyright © 2019 Celiña Hiyas Javier. All rights reserved.
//

import UIKit
import SnapKit

public class ChecklistItemHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Delegates
    public weak var delegate: ChecklistItemHeaderViewDelegate?

    // MARK: - Subviews
    private let checkboxButton: UIButton = {
        let view: UIButton = UIButton()
        view.setImage(#imageLiteral(resourceName: "uncheck-checkBox"), for: UIControl.State.normal)
        view.addTarget(self, action: #selector(ChecklistItemHeaderView.tapCheckbox), for: UIControl.Event.touchUpInside)
        return view
    }()
    
    private let itemLabel: UILabel = {
        let view: UILabel = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 16.0)
        view.textColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.0)
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.left
        view.adjustsFontSizeToFitWidth = true
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    // MARK: Stored Properties
    private var section: Int = 0

    // MARK: Initializers
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.subviews(forAutoLayout: [self.checkboxButton, self.itemLabel])
        
        self.checkboxButton.snp.remakeConstraints { (make: ConstraintMaker) in
            make.leading.equalToSuperview().offset(20.0)
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        self.itemLabel.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) in
            make.leading.equalTo(self.checkboxButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Target Action Methods
extension ChecklistItemHeaderView {
    
    @objc public func tapCheckbox(_sender: UIButton) {
        guard let delegate = self.delegate else { return }
        delegate.didTapCheckbox(section: section)
    }
}

// MARK: - Public APIs
extension ChecklistItemHeaderView {
    public static var identifier: String = "ChecklistItemHeaderView"
    
    public func setTitle(_ title: String) {
        self.itemLabel.text = title
    }
    
    public func setSection(_ section: Int) {
        self.section = section
    }
}


