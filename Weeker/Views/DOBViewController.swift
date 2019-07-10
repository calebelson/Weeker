//
//  DOBViewController.swift
//  Weeker
//
//  Created by Caleb Elson on 11/30/18.
//  Copyright © 2018 Caleb Elson. All rights reserved.
//

import UIKit

class DOBViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var dateOfBirthPicker: UIDatePicker!
    @IBOutlet weak var defaultStyleButton: UIButton!
    @IBOutlet weak var grayScaleButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var firstLoad = UserDefaults(suiteName: "group.com.calebElson.Weeker")?.value(forKey: "syncDOB") == nil
    var theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        tableViewTitles = ["App Theme","Acknowledgments"]
        storyBoardIDs = ["ThemeChangeTableView", "AcknowledgmentsVC"]
        
        setupView()
        
        if firstLoad {
            navigationItem.hidesBackButton = true
        } else {
            navigationItem.hidesBackButton = false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        dateOfBirthPicker.maximumDate = Date()
        dateOfBirthPicker.setValue(false, forKey: "highlightsToday")
        
        if let dob = UserDefaults(suiteName: "group.com.calebElson.Weeker")?.value(forKey: "syncDOB") {
            dateOfBirthPicker.setDate(dob as! Date, animated: false)
        } else {
            let date = dateFormatter.date(from: "1995-06-15")
            dateOfBirthPicker.setDate(date!, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let selectedRow = settingsTableView.indexPathForSelectedRow
        if let selectedRowNotNil = selectedRow {
            settingsTableView.deselectRow(at: selectedRowNotNil, animated: true)
        }
        setupView()
        settingsTableView.reloadData()

    }
    
    func setupView() {
        theme = ThemeManager.currentTheme()
        dateOfBirthPicker.setValue(theme.primaryColor, forKey: "textColor")
        navigationController?.navigationBar.tintColor = theme.primaryColor
        saveButton.tintColor = theme.primaryColor
    }
    
    @IBAction func saveButtonPushed(_ sender: Any) {
        let date = dateOfBirthPicker.date
        UserDefaults(suiteName: "group.com.calebElson.Weeker")?.set(date, forKey: "syncDOB")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - TableView Setup
    var tableViewTitles = [String]()
    var storyBoardIDs = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel!.text = tableViewTitles[indexPath.row]
        cell?.textLabel?.textColor = theme.primaryColor
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcName = storyBoardIDs[indexPath.row]
        let viewController = storyboard?.instantiateViewController(withIdentifier: vcName)
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}
