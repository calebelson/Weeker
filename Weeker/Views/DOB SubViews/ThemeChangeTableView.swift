//
//  ThemeChangeViewController.swift
//  Weeker
//
//  Created by Caleb Elson on 7/10/19.
//  Copyright © 2019 Caleb Elson. All rights reserved.
//

import UIKit

class ThemeChangeTableView: UITableViewController {
    var names = [String]()
    var theme = ThemeManager.currentTheme()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell")
        
        cell?.textLabel?.text = names[indexPath.row]
        cell?.textLabel?.textColor = ThemeManager.currentTheme().primaryColor
        
        if "\(theme)" == names[indexPath.row] {
            cell?.accessoryType = .checkmark
            // Allows for didDeselect to be called if another row is tapped
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        ThemeManager.applyTheme(theme: Theme(rawValue: names[indexPath.row])!)
        setupView()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    override func viewDidLoad() {
        names = ["Default","GrayScale"]
        // Checkmark loads as correct color
        tableView.tintColor = theme.primaryColor
    }
    
    func setupView() {
        theme = ThemeManager.currentTheme()
        navigationController?.navigationBar.tintColor = theme.primaryColor
        tableView.tintColor = theme.primaryColor
        tableView.reloadData()
    }
}
