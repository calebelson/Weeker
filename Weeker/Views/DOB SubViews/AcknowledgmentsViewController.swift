//
//  AcknowledgmentsViewController.swift
//  Weeker
//
//  Created by Caleb Elson on 7/10/19.
//  Copyright © 2019 Caleb Elson. All rights reserved.
//

import UIKit
import SafariServices

class AcknowledgmentsViewController: UIViewController {
    @IBOutlet weak var tedTalkLabel: UILabel!
    let theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tedTalkLabel.textColor = theme.primaryColor
        
        let inspirationText = "App inspired by"
        let youtubeLink = "this Ted Talk on procrastination"

        let labelString = "\(inspirationText)\n\(youtubeLink)"

        let range = (labelString as NSString).range(of: youtubeLink)
        let attributedString = NSMutableAttributedString.init(string: labelString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: theme.secondaryColor, range: range)

        tedTalkLabel.attributedText = attributedString
    }

    
    @IBAction func tedTalkLabelTapped(_ sender: Any) {
        let myURL = URL(string: "https://www.youtube.com/watch?v=arj7oStGLkU")
        let tedTalkVideoVC = SFSafariViewController(url: myURL!)
        present(tedTalkVideoVC, animated: true)
    }
}
