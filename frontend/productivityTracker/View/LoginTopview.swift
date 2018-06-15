//
//  LoginTopview.swift
//  productivityTracker
//
//  Created by Eri on 6/11/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit

class LoginTopview: UIView
{
    let todoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "todo.jpg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // designated init of TodoTopview
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(todoImageView)
    }
    
    func setupConstraints() {
        setupTodoImageView()
    }
    
    func setupTodoImageView() {
        todoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        todoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        todoImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
