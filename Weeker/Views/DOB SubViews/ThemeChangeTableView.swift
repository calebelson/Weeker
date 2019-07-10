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
    var identities = [String]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell")
        
        cell?.textLabel?.text = names[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func viewDidLoad() {
        names = ["First","Second"]
        identities = ["A", "B"]
    }
}
