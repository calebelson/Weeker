//
//  TodayViewController.swift
//  Weeker Widget
//
//  Created by Caleb Elson on 1/6/19.
//  Copyright © 2019 Caleb Elson. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var lifeProgress: UIProgressView!
    @IBOutlet weak var livedAndLeftLabel: UILabel!
    
    // Open main app
    @IBAction func widgetTapped(_ sender: UITapGestureRecognizer) {
        let url = URL(string: "mainAppUrl://")!
        self.extensionContext?.open(url, completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Checks if DOB has been set
        if let _ = UserDefaults(suiteName: "group.com.calebElson.Weeker")?.value(forKey: "DOB") {
            let ageModel = AgeModel()

            let weeksLivedString = "Weeks Lived: \(ageModel.weeksLivedAndLeft().weeksLived), \(ageModel.weeksLivedAndLeft().percentLived)%"
            let weeksLeftString = "Weeks Left: \(ageModel.weeksLivedAndLeft().weeksLeft), \(ageModel.weeksLivedAndLeft().percentLeft)%"

            livedAndLeftLabel.text = "\(weeksLivedString)\n\(weeksLeftString)"
            lifeProgress.progress = Float(ageModel.weeksLivedAndLeft().percentLived)/100
            
        } else {
            livedAndLeftLabel.text = "Tap to set date of birth"
            lifeProgress.progress = 0
        }
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
