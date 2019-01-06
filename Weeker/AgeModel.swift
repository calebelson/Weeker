//
//  AgeModel.swift
//  Weeker
//
//  Created by Caleb Elson on 1/5/19.
//  Copyright © 2019 Caleb Elson. All rights reserved.
//

import Foundation

class AgeModel {
     let dateOfBirth = UserDefaults.standard.value(forKey: "DOB")
    
    func weeksLivedAndLeft() -> (weeksLived: Int, weeksLeft: Int, percentLived: Int) {
        let lifeSpan = Int(90*365.25)
        let daysLived = Calendar.current.dateComponents([.day], from: dateOfBirth as! Date, to: Date()).day!
        
        let weeksLived = daysLived/7
        let weeksLeft = (lifeSpan - daysLived)/7
        let percentLived = daysLived*100/lifeSpan
        
        return (weeksLived, weeksLeft, percentLived)
    }
    
    func current() -> (year: Int, weekOfYear: Int) {
        let timeSinceDOB: DateComponents = Calendar.current.dateComponents([.year, .weekOfYear], from: dateOfBirth as! Date, to: Date())
        
        return (timeSinceDOB.year!, timeSinceDOB.weekOfYear!)
    }
}
