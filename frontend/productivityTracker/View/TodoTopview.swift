//
//  topViewMainVC.swift
//  productivityTracker
//
//  Created by Eri on 4/23/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit

class TodoTopview: UIView
{
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        label.textColor = UIColor(percent: 0.50)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addGroupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Group...", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        button.setTitleColor(UIColor(percent: 0.50), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // designated init of TodoTopview
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
        addSubview(timeLabel)
        addSubview(addGroupButton)
    }
    
    func setupConstraints() {
        setupTimeLabel()
        setupAddGroupButton()
    }
    
    func setupTimeLabel() {
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupAddGroupButton() {
        addGroupButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        addGroupButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        addGroupButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
