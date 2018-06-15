//
//  DayVCExtension.swift
//  productivityTracker
//
//  Created by Eri on 6/7/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit

extension DayVC: UITableViewDataSource, UITableViewDelegate
{
    func addSubviews() {
        view.addSubview(daysTableView)
    }

    func setupConstraints() {
        setupDaysTableView()
    }
    
    func setupDaysTableView() {
        daysTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        daysTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        daysTableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        daysTableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        let index = indexPath.row
        let day = days[index]
        cell.textLabel?.text = day.date?.getDateStr()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        // disable cell selection after returning from TodoVC
        tableView.deselectRow(at: indexPath, animated: true)
        
        presentTodoVC(days[index].date)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            
            let day = days[index]
            // remove group from array
            days.remove(at: index)
            
            // reload tableview
            tableView.reloadData()
            
            // remove groups from db
            for id in day.groupIds {
                deleteGroup(id)
            }
        }
    }
    
    private func presentTodoVC(_ date: Date?) {
        let todoVC = TodoVC()
        let navController = UINavigationController(rootViewController: todoVC)
        todoVC.user = user
        todoVC.date = date
        present(navController, animated: true, completion: nil)
    }
}
