//
//  extensions.swift
//  productivityTracker
//
//  Created by Eri on 4/23/18.
//  Copyright © 2018 Eri. All rights reserved.
//

import UIKit

extension DateFormatter {
    func todaysDate() -> String {
        // initially set the format based on your datepicker date / server String
        self.dateFormat = "MM-dd-yy"
        
        return self.string(from: Date())
    }
}

extension Date {
    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getDateStr() -> String {
        return self.getMonth() + "-" + self.getDay() + "-" + self.getYear()
    }
    
    func isOld() -> Bool {
        let today = Date()
        let year = today.getYear()
        let month = today.getMonth()
        let day = today.getDay()
        
        return (self.getYear() < year ||  self.getMonth() < month || self.getDay() < day)
    }
}

extension UIColor {
    convenience init(percent: CGFloat) {
        self.init(red: percent, green: percent, blue: percent, alpha: 1.0)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if (rows > 0){
            self.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: true)
        }
    }
    
    func calcScrollPoint() {
        DispatchQueue.main.async {
            let contentHeight = self.contentSize.height
            let frameheight = self.frame.size.height
            let diff = contentHeight - frameheight
            let yOffset = (diff > 0) ? diff : 0
            let scrollPoint = CGPoint(x: 0, y: yOffset)
            self.setContentOffset(scrollPoint, animated: true)
        }
    }
}

extension String {
    func trimTrailingWhiteSpaces() -> String {
        var newString = self
        
        while newString.hasSuffix(" ") {
            newString = String(newString.dropLast())
        }
        
        return newString
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    func isInt() -> Bool {
        return Int(self) != nil
    }
}

extension UIViewController {
    func createAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
