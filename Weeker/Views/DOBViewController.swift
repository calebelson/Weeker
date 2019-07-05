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
    @IBOutlet weak var defaultStyleButton: UIButton!
    @IBOutlet weak var grayScaleButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var firstLoad = UserDefaults(suiteName: "group.com.calebElson.Weeker")?.value(forKey: "syncDOB") == nil
    
    override func viewDidLoad() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        dateOfBirthPicker.maximumDate = Date()
        
        setupView()
        
        defaultStyleButton.layer.cornerRadius = 25
        defaultStyleButton.clipsToBounds = true
        grayScaleButton.layer.cornerRadius = 25
        grayScaleButton.clipsToBounds = true
        
        if firstLoad {
            navigationItem.hidesBackButton = true
        } else {
            navigationItem.hidesBackButton = false
        }
        
        print(ThemeManager.currentTheme())
        
        if let dob = UserDefaults(suiteName: "group.com.calebElson.Weeker")?.value(forKey: "syncDOB") {
            dateOfBirthPicker.setDate(dob as! Date, animated: false)
        } else {
            let date = dateFormatter.date(from: "1995-06-15")
            dateOfBirthPicker.setDate(date!, animated: false)
        }
    }
    
    func setupView() {
        let theme = ThemeManager.currentTheme()
        dateOfBirthPicker.setValue(theme.primaryColor, forKey: "textColor")
        navigationController?.navigationBar.tintColor = theme.primaryColor
        saveButton.tintColor = theme.primaryColor
    }
    
    @IBAction func defaultStyleButtonPressed(_ sender: Any) {
        ThemeManager.applyTheme(theme: Theme(rawValue: "Default")!)
        setupView()
        print(ThemeManager.currentTheme())
    }
    @IBAction func grayScaleButtonPressed(_ sender: Any) {
        ThemeManager.applyTheme(theme: Theme(rawValue: "GrayScale")!)
        setupView()
        print(ThemeManager.currentTheme())
    }
    
    @IBAction func saveButtonPushed(_ sender: Any) {
        let date = dateOfBirthPicker.date
        UserDefaults(suiteName: "group.com.calebElson.Weeker")?.set(date, forKey: "syncDOB")
        
        self.navigationController?.popViewController(animated: true)
    }
}
