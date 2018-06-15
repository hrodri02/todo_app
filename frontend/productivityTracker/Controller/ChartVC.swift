//
//  ChartsVC.swift
//  productivityTracker
//
//  Created by Eri on 5/26/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit
import Charts

protocol GetChartDataDelegate: class {
    func getChartData(barChart: BarChart)
}

class ChartVC: UIViewController, GetChartDataDelegate
{
    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(percent: 0.87)
        navigationItem.title = group?.name
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleBack))
        
        displayBarChart()
    }
    
    func displayBarChart() {
        let barChart = BarChart(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height))
        barChart.delegate = self
        barChart.getData()
        barChart.setup()
        self.view.addSubview(barChart)
    }
    
    func getChartData(barChart: BarChart)
    {
        guard let groupTasks = group?.task else {return}
        for i in 0 ..< groupTasks.count {
            if groupTasks[i].totalSeconds > 0
            {
                barChart.tasks.append(groupTasks[i].name)
                
                let totSecs = groupTasks[i].totalSeconds
                let mins = Float(totSecs) / 60
                barChart.minsPerTask.append("\(mins)")
            }
        }
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
}

public class ChartFormatter: NSObject, IAxisValueFormatter {
    
    var tasks = [String]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return tasks[Int(value)]
    }
    
    public func setValues(values: [String]) {
        self.tasks = values
    }
}
