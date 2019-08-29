//
//  Theme.swift
//  Weeker
//
//  Created by Caleb Elson on 7/4/19.
//  Copyright © 2019 Caleb Elson. All rights reserved.
//


import UIKit
import Foundation

enum Theme: String {
    
    case Default, Mono
    
    var primaryColor: UIColor {
        switch self {
        case .Default:
            return UIColor(named: "defaultPrimary")!
        case .Mono:
            return UIColor(named: "monoPrimary")!
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .Default:
            return UIColor(named: "defaultSecondary")!
        case .Mono:
            return UIColor(named: "monoSecondary")!
        }
    }
    
    var titleTextColor: UIColor {
        switch self {
        case .Default:
            return UIColor(named: "defaultPrimary")!
        case .Mono:
            return UIColor(named: "monoPrimary")!
        }
    }
    
    var subtitleTextColor: UIColor {
        switch self {
        case .Default:
            return UIColor(named: "defaultPrimary")!
        case .Mono:
            return UIColor(named: "monoPrimary")!
        }
    }
    
    var progressPrimaryColor: UIColor {
        switch self {
        case .Default:
            return UIColor(named: "defaultPrimary")!
        case .Mono:
            return UIColor(named: "monoProgressPrimary")!
        }
    }
    
    var progressSecondaryColor: UIColor {
        switch self {
        case .Default:
            return UIColor(named: "defaultSecondary")!
        case .Mono:
            return UIColor(named: "monoProgressSecondary")!
        }
    }
}

let SelectedThemeKey = "syncSelectedTheme"

struct ThemeManager {
    
    // ThemeManager
    static func currentTheme() -> Theme {
        if let storedTheme = UserDefaults(suiteName: "group.com.calebElson.Weeker")?.value(forKey: SelectedThemeKey) {
            return Theme(rawValue: storedTheme as! String)!
        } else {
            return Theme(rawValue: "Default")!
        }
    }
    
    static func applyTheme(theme: Theme) {
        UserDefaults(suiteName: "group.com.calebElson.Weeker")?.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults(suiteName: "group.com.calebElson.Weeker")?.synchronize()
    }
}
