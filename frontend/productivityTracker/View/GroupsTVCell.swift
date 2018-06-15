//
//  GroupsTVCell.swift
//  productivityTracker
//
//  Created by Eri on 4/27/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit

class GroupsTVCell: UITableViewCell
{
    
    let groupTitleTextField: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont(name: "AvenirNext-Bold", size: 14.0)
        textfield.backgroundColor = UIColor(percent: 0.87)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let chartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "bar_chart")
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let bottomPadding: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(percent: 0.87)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "GroupsTVCell")
        backgroundColor = .white
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(groupTitleTextField)
        addSubview(bottomPadding)
        addSubview(chartImageView)
    }
    
    func setupConstraints() {
        setupGroupTitleTextField()
        setupBottomPadding()
        setupChartsImageView()
    }
    
    func setupGroupTitleTextField() {
        groupTitleTextField.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        groupTitleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        groupTitleTextField.widthAnchor.constraint(equalToConstant: frame.width / 2).isActive = true
    }
    
    func setupBottomPadding() {
        bottomPadding.heightAnchor.constraint(equalToConstant: 10).isActive = true
        bottomPadding.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomPadding.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomPadding.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func setupChartsImageView() {
        chartImageView.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        chartImageView.bottomAnchor.constraint(equalTo: bottomPadding.topAnchor, constant: -7).isActive = true
        chartImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7).isActive = true
        chartImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
}
