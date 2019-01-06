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
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "transitionViewControllerID")
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
}