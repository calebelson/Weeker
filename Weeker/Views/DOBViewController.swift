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
    
    @IBAction func saveButtonPushed(_ sender: Any) {
        
        let date = dateOfBirthPicker.date
        UserDefaults.standard.set(date, forKey: "DOB")
        
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(TransitionViewController(), animated: false, completion: nil)
    }
}
