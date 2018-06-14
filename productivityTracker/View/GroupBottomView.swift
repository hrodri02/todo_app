//
//  GroupBottomView.swift
//  productivityTracker
//
//  Created by Eri on 4/30/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit

class GroupBottomView: UIView {
    let addTaskLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Add Task..."
        label.font = UIFont(name: "AvenirNext-Bold", size: 15.0)
        label.textColor = UIColor(percent: 0.50)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor(percent: 0.87)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(addTaskLabel)
    }
    
    func setupConstraints() {
        setupAddTaskLabel()
    }
    
    func setupAddTaskLabel() {
        addTaskLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        addTaskLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
    }
}
