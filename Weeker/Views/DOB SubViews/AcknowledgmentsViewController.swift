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
    @IBOutlet weak var actuarialDataLabel: UILabel!
    @IBOutlet weak var iconExplanationLabel: UILabel!
    
    let theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // actuarialDataLabel setup
        actuarialDataLabel.textColor = theme.primaryColor
        actuarialDataLabel.attributedText = underlineText(beginningString: "Data sourced from", linkString: "the U.S. Social Security Administration")
        
        // tedTalkLabel setup
        tedTalkLabel.textColor = theme.primaryColor
        tedTalkLabel.attributedText = underlineText(beginningString: "App inspired by", linkString: "this Ted Talk on procrastination")
        
        // iconExplanationLabel setup
        iconExplanationLabel.textColor = theme.primaryColor
        iconExplanationLabel.attributedText = underlineText(beginningString: "Why is the icon a sphinx?", linkString: "It walks on four legs in the morning, two legs at noon and three legs in the evening")
    }
    
    func underlineText(beginningString: String, linkString: String) -> NSMutableAttributedString {
        
        let labelString = "\(beginningString)\n\(linkString)"
        let range = (labelString as NSString).range(of: linkString)
        let attributeString = NSMutableAttributedString.init(string: labelString)
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        
        return attributeString
    }
    
    func presentWebView(url: String) {
        let myURL = URL(string: url)
        let sfVC = SFSafariViewController(url: myURL!)
        present(sfVC, animated: true)
    }
    
    @IBAction func tedTalkLabelTapped(_ sender: Any) {
        presentWebView(url: "https://www.youtube.com/watch?v=arj7oStGLkU")
    }
    
    @IBAction func actuarialDataLabelTapped(_ sender: Any) {
        presentWebView(url: "https://www.ssa.gov/OACT/STATS/table4c6.html")
    }
    
    @IBAction func iconExplanationLabelTapped(_ sender: Any) {
        presentWebView(url: "https://en.m.wikipedia.org/wiki/Sphinx#Riddle_of_the_Sphinx")
    }
}
