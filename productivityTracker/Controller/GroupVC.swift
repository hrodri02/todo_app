//
//  GroupVC.swift
//  productivityTracker
//
//  Created by Eri on 4/29/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit

class GroupVC: UIViewController {
    let topView = GroupTopView()
    
    let checklistTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white //UIColor(percent: 0.87)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let bottomView = GroupBottomView()
    
    var user: User?
    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(percent: 0.87)
        
        navigationItem.title = group?.name
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(handleBackButton))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        checklistTableView.dataSource = self
        checklistTableView.delegate = self
        checklistTableView.allowsSelection = false
        checklistTableView.register(GroupTVCell.self, forCellReuseIdentifier: "GroupTVCell")
        
        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddTask)))
        
        updateChecklistProgress()
        addSubviews()
        setupConstraints()
        hideKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // deactivate any timers
        guard let tasks = group?.task else {return}
        for task in tasks {
            if task.isTimerRunning {
                task.timer.invalidate()
                task.isTimerRunning = false
            }
        }
    }
    
    func updateChecklistProgress() {
        self.group?.numTasksCompletedDidChangeClosure = {
            print("update progress")
            guard let progress = self.group?.fractionOfTaskCompleted() else {return}
            print("progress: ", progress)
            self.topView.checklistProgressView.progress = progress
            self.topView.progressLabel.text = "\(round(self.topView.checklistProgressView.progress * 10000) / 100) %"
        }
    }
    
    @objc func handleBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAddTask() {
        guard let numTasks = group?.task.count else {return}
        if numTasks < MAX_TASKS_PER_GROUP {
            group?.task.append(Task())
            checklistTableView.reloadData()
            checklistTableView.calcScrollPoint()
        }
        else {
            createAlert(title: "Error", msg: "You cannot add more than \(MAX_TASKS_PER_GROUP) tasks per group!")
        }
    }
}
