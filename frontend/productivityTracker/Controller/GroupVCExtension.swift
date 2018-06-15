//
//  GroupVCExtension.swift
//  productivityTracker
//
//  Created by Eri on 4/30/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit

extension GroupVC: UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate
{
    func addSubviews()
    {
        view.addSubview(topView)
        view.addSubview(checklistTableView)
        view.addSubview(bottomView)
    }
    
    func setupConstraints() {
        setupTopView()
        setupChecklistTableView()
        setupBottomView()
    }
    
    func setupTopView() {
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: view.frame.height / 12).isActive = true
    }
    
    func setupChecklistTableView() {
        checklistTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        checklistTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        checklistTableView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        checklistTableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
    }
    
    func setupBottomView() {
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: view.frame.height / 16).isActive = true
    }
    
    // MARK: - table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numTasks = group?.task.count else {return 0}
        return numTasks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTVCell", for: indexPath) as! GroupTVCell
        
        cell.groupVC = self
        
        let index = indexPath.row
        cell.task = group?.task[index]
        
        cell.imageView?.tag = index
        
        if (group?.task[index].name == "") {
            cell.taskNameTextField.becomeFirstResponder()
        }
        
        cell.taskNameTextField.delegate = self
        cell.taskNameTextField.tag = index
        cell.taskNameTextField.text = group?.task[index].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            guard let taskId = group?.task[index].id else {return}
            
            // remove task from array
            group?.task.remove(at: index)
            
            // reload tableview
            tableView.reloadData()
            
            // remove task from db
            guard let groupId = group?.id else {return}
            deleteTask(groupId, taskId)
        }
    }
    
    
    // MARK: - table view delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    // MARK: - textfield functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if var taskName = textField.text {
            let index = textField.tag
            taskName = taskName.trimTrailingWhiteSpaces()
            
            let oldTaskName = group?.task[index].name
            group?.task[index].name = taskName
            
            guard let groupId = group?.id else {return}
            guard let task = group?.task[index] else {return}
            
            if (task.id == nil) {
                postTask(groupId, task, completionHandler: setIdOfTask)
                
            }
            else if (oldTaskName != taskName) {
                putTask(groupId, task)
            }
        }
    }
    
    // MARK: - hiding keyboard functions
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
