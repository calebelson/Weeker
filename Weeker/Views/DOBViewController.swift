//
//  DOBViewController.swift
//  Weeker
//
//  Created by Caleb Elson on 11/30/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import UIKit
import SVProgressHUD

class DOBViewController: UIViewController {
    @IBOutlet weak var dateOfBirthPicker: UIDatePicker!
    
    override func viewDidLoad() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        dateOfBirthPicker.maximumDate = Date()
        
        if let dob = UserDefaults(suiteName: "group.com.calebElson.Weeker")?.value(forKey: "DOB") {
            dateOfBirthPicker.setDate(dob as! Date, animated: false)
        } else {
            let date = dateFormatter.date(from: "1995-06-15")
            dateOfBirthPicker.setDate(date!, animated: false)
        }
    }
    
    @IBAction func saveButtonPushed(_ sender: Any) {
        
        let date = dateOfBirthPicker.date
        UserDefaults(suiteName: "group.com.calebElson.Weeker")?.set(date, forKey: "DOB")
        
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(TransitionViewController(), animated: false, completion: nil)
    }
}
