//
//  LoginVC.swift
//  productivityTracker
//
//  Created by Eri on 5/28/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginVC: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate
{
    let currentUser =  User()
    let topView = LoginTopview()
    let bottomView = LoginBottomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        addSubviews()
        setupConstraints()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            currentUser.name = user.profile.name
            currentUser.email = user.profile.email
            currentUser.authToken = user.authentication.idToken
            guard let idToken = user.authentication.idToken else {return}
            print(idToken)
            siginWithToken(user.profile.name, token: idToken, completionHandler: saveUserId)
        }
    }
    
    func saveUserId(_ id: String?, _ err: NSError?) {
        if let uid = id {
            currentUser.id = uid
            presentTodoVC()
        }
        else if let error = err {
            print("status code \(error.code):", error.localizedDescription)
        }
    }
    
    func presentTodoVC() {
        let todoVC = TodoVC()
        todoVC.user = currentUser
        todoVC.date = Date()
        let navController = UINavigationController(rootViewController: todoVC)
        present(navController, animated: true, completion: nil)
    }
    
//    func saveUserIDAndToken(_ id: String, _ authToken: String?) {
//        currentUser.id = id
//        currentUser.authToken = authToken
//        presentTodoVC()
//    }
//
//    func saveAuthToken(_ authToken: String?) {
//        currentUser.authToken = authToken
//        presentTodoVC()
//    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func addSubviews() {
        view.addSubview(bottomView)
        view.addSubview(topView)
    }
    
    func setupConstraints() {
        setupBottomView()
        setupTopView()
    }
    
    func setupBottomView() {
        // set x, y, width, and height constraints
        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: view.frame.height / 4).isActive = true
    }
    
    func setupTopView() {
        topView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
