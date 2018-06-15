//
//  TodoVCExtension.swift
//  productivityTracker
//
//  Created by Eri on 4/23/18.
//  Copyright © 2018 Eri. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

extension TodoVC: UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate
{
    func addSubviews() {
        view.addSubview(topView)
        view.addSubview(groupsTableView)
        view.addSubview(bottomView)
    }
    
    func setupConstraints() {
        setupTopView()
        setupGroupTableView()
        setupBottomView()
    }
    
    func setupTopView() {
        topView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
    func setupGroupTableView() {
        groupsTableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10).isActive = true
        groupsTableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -10).isActive = true
        groupsTableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        groupsTableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
    func setupBottomView() {
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: view.frame.height / 16).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // MARK: - tableview data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTVCell", for: indexPath) as? GroupsTVCell
        
        let index = indexPath.row
        
        if (group[index].name == "") {
            cell?.groupTitleTextField.becomeFirstResponder()
        }
        
        cell?.groupTitleTextField.delegate = self
        cell?.groupTitleTextField.tag = index
        cell?.groupTitleTextField.text = group[index].name
        
        cell?.chartImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChartsImageViewTap)))
        
        return cell!
    }
    
    @objc func handleChartsImageViewTap(sender: UITapGestureRecognizer)
    {
        // get the point in respect to the tableview
        let tapLocation = sender.location(in: self.groupsTableView)
        
        //using the tapLocation, we retrieve the corresponding indexPath
        let indexPath = self.groupsTableView.indexPathForRow(at: tapLocation)
        
        guard let index = indexPath?.row else {return}
        
        let chartVC = ChartVC()
        let navController = UINavigationController(rootViewController: chartVC)
        chartVC.group = group[index]
        present(navController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            guard let groupId = group[index].id else {return}
            
            // remove group from array
            group.remove(at: index)
            
            // reload tableview
            tableView.reloadData()
            
            // remove group from db
            deleteGroup(groupId)
        }
    }
    
    // MARK: - tableview delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
            tableView.scrollToBottom(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        // disable cell selection after returning from GroupVC
        tableView.deselectRow(at: indexPath, animated: true)
        
        let groupVC = GroupVC()
        let navController = UINavigationController(rootViewController: groupVC)
        groupVC.user = user
        groupVC.group = group[index]
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - textfield functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // called when keyboard is dismissed and when user presses return on keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        if var groupName = textField.text {
            let index = textField.tag
            groupName = groupName.trimTrailingWhiteSpaces()
            
            let oldGroupName = group[index].name
            group[index].name = groupName
            
            if (group[index].id == nil) {
                // post new group in database
                postGroup(group[index], completionHandler: saveGroupInDict)
            }
            else if (oldGroupName != groupName) {
                guard let groupId = group[index].id else {return}
                groupsDict[groupId]?.name = groupName
                
                // update group in  database
                putGroup(groupId)
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
        print("keyboard dismissed")
        view.endEditing(true)
    }
}
