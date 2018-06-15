//
//  ViewController.swift
//  productivityTracker
//
//  Created by Eri on 4/23/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit

class TodoVC: UIViewController
{
    let topView = TodoTopview()
    
    let groupsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(percent: 0.87)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let bottomView = TodoBottomView()
    
    
    
    var user: User?
    
    var date: Date? {
        didSet {
            topView.timeLabel.text = date?.getDateStr()
        }
    }
    var group: [Group] = []
    var groupsDict: [String:Group] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(percent: 0.87)
        
        
        guard let dateOfList = date else {return}
        
        if dateOfList.isOld() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
            bottomView.isUserInteractionEnabled = false
            topView.isUserInteractionEnabled = false
            groupsTableView.allowsSelection = false
        }
        else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "archive"), style: .plain, target: self, action: #selector(handleArchive))
        }
        
        groupsTableView.dataSource = self
        groupsTableView.delegate = self
        groupsTableView.register(GroupsTVCell.self, forCellReuseIdentifier: "GroupsTVCell")
        
        topView.addGroupButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addGroupButtonPressed)))
        
        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addGroupButtonPressed)))
        
        downloadGroups( completionHandler: initGroups )
        addSubviews()
        setupConstraints()
    }
    
    @objc func handleLogout()
    {
        user?.authToken = nil
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleBack()
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleArchive() {
        presentDayVC()
    }
    
    func presentDayVC() {
        let dayVC = DayVC()
        dayVC.user = user
        let navController = UINavigationController(rootViewController: dayVC)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func addGroupButtonPressed() {
        if group.count < MAX_GROUPS_PER_DAY {
            group.append(Group())
            groupsTableView.reloadData()
            groupsTableView.calcScrollPoint()
        }
        else {
            createAlert(title: "Error", msg: "You cannot add more than \(MAX_GROUPS_PER_DAY) groups per day!")
        }
    }
}
