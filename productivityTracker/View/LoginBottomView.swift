//
//  LoginBottomView.swift
//  productivityTracker
//
//  Created by Eri on 5/29/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginBottomView: UIView
{
    let googleSigninButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // designated init of LoginBottomView
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor(percent: 0.87)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(googleSigninButton)
    }
    
    func setupConstraints() {
        setupGoogleSigninButton()
    }
    
    func setupGoogleSigninButton()
    {
        googleSigninButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        googleSigninButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        googleSigninButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        googleSigninButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
}

