//
//  GroupTopView.swift
//  productivityTracker
//
//  Created by Eri on 4/30/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit

class GroupTopView: UIView
{
    let checklistLabel: UILabel = {
        let label = UILabel()
        label.text = "Checklist"
        label.font = UIFont(name: "AvenirNext-Bold", size: 20.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var checklistProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.center = self.center
        progressView.progress = 0.0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "\(round(self.checklistProgressView.progress * 10000) / 100) %"
        label.textColor = UIColor(percent: 0.5)
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
    
    func addSubviews()
    {
        addSubview(checklistLabel)
        addSubview(checklistProgressView)
        addSubview(progressLabel)
    }
    
    func setupConstraints()
    {
        setupChecklistLabel()
        setupProgressLabel()
        setupChecklistProgressView()
    }
    
    func setupChecklistLabel() {
        checklistLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        checklistLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    }
    
    func setupProgressLabel() {
        progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        progressLabel.topAnchor.constraint(equalTo: checklistLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    func setupChecklistProgressView() {
        checklistProgressView.leftAnchor.constraint(equalTo: progressLabel.rightAnchor, constant: 5).isActive = true
        checklistProgressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        checklistProgressView.topAnchor.constraint(equalTo: checklistLabel.bottomAnchor, constant: 11).isActive = true
    }
}
