//
//  DOBViewController.swift
//  Weeker
//
//  Created by Caleb Elson on 11/30/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import UIKit

class DOBViewController: UIViewController {
    @IBOutlet weak var dateOfBirthPicker: UIDatePicker!
    
    var firstLoad = UserDefaults(suiteName: "group.com.calebElson.Weeker")?.value(forKey: "syncDOB") == nil
    
    override func viewDidLoad() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        dateOfBirthPicker.maximumDate = Date()
        
        dateOfBirthPicker.setValue(#colorLiteral(red: 0.6979569793, green: 0.8412405849, blue: 0.9987565875, alpha: 1), forKeyPath: "textColor")
        
        
        if let dob = UserDefaults(suiteName: "group.com.calebElson.Weeker")?.value(forKey: "syncDOB") {
            dateOfBirthPicker.setDate(dob as! Date, animated: false)
        } else {
            let date = dateFormatter.date(from: "1995-06-15")
            dateOfBirthPicker.setDate(date!, animated: false)
        }
    }
    
    @IBAction func saveButtonPushed(_ sender: Any) {
        let date = dateOfBirthPicker.date
        UserDefaults(suiteName: "group.com.calebElson.Weeker")?.set(date, forKey: "syncDOB")
        
        self.navigationController?.popViewController(animated: true)
    }
}
