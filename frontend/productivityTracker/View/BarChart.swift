//
//  BarChart.swift
//  productivityTracker
//
//  Created by Eri on 5/26/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit
import Charts

class BarChart: UIView
{
    // bar chart properties
    let barChartView = BarChartView()
    var dataEntry: [BarChartDataEntry] = []
    
    // chart data
    var tasks = [String]()
    var minsPerTask = [String]()
    
    weak var delegate: GetChartDataDelegate!
    
    func getData() {
        delegate.getChartData(barChart: self)
    }
    
    func setup() {
        // bar chart setup
        self.backgroundColor = .white
        self.addSubview(barChartView)
        
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        barChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        barChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        barChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // bar chart population
        setBarChart(dataPoints: tasks, values: minsPerTask)
    }
    
    func setBarChart(dataPoints: [String], values: [String]) {
        // no data setup
        barChartView.noDataTextColor = .black
        barChartView.noDataText = "No data for the chart"
        barChartView.backgroundColor = .white
        
        // data point setup and color config
        for i in 0 ..< dataPoints.count {
            let dataPoint = BarChartDataEntry(x: Double(i), y: Double(values[i])!)
            dataEntry.append(dataPoint)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntry, label: "Minutes vs. Tasks")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true)
        
        // axes setup
        let formatter = ChartFormatter()
        formatter.setValues(values: dataPoints)
        let xaxis = XAxis()
        xaxis.valueFormatter = formatter
        barChartView.xAxis.valueFormatter = xaxis.valueFormatter
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.granularity = 1.0
        
        barChartView.chartDescription?.enabled = false
        barChartView.legend.enabled = true
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = true
        barChartView.data = chartData
    }
}
