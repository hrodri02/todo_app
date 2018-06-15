//
//  TodoVCBottomview.swift
//  productivityTracker
//
//  Created by Eri on 4/25/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit

class TodoBottomView: UIView {
    let addGroupLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Group..."
        label.font = UIFont(name: "AvenirNext-Bold", size: 15.0)
        label.textColor = UIColor(percent: 0.50)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // designated init of TodoBottomView
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor(percent: 0.77)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(addGroupLabel)
    }
    
    func setupConstraints() {
        setupAddGroupLabel()
    }
    
    func setupAddGroupLabel() {
        addGroupLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        addGroupLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
    }
}
