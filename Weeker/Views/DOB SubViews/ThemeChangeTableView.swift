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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell")
        
        cell?.textLabel?.text = names[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    override func viewDidLoad() {
        names = ["First","Second"]
    }
}
