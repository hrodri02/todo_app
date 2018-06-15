//
//  DayVC.swift
//  productivityTracker
//
//  Created by Eri on 6/7/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit

class DayVC: UIViewController
{
    let daysTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(percent: 0.87)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var user: User?
    var days: [Day] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(percent: 0.87)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        daysTableView.dataSource = self
        daysTableView.delegate = self
//        groupsTableView.register(DayTVCell.self, forCellReuseIdentifier: "GroupsTVCell")
        
        getDays( completionHandler: initDates )
        addSubviews()
        setupConstraints()
    }
    
    @objc func handleBack()
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addGroupButtonPressed() {
        days.append(Day())
        daysTableView.reloadData()
        daysTableView.calcScrollPoint()
    }
}
