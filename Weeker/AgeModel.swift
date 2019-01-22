//
//  AgeModel.swift
//  Weeker
//
//  Created by Caleb Elson on 1/5/19.
//  Copyright © 2019 Caleb Elson. All rights reserved.
//

import Foundation

class AgeModel {
     let dateOfBirth = UserDefaults(suiteName: "group.com.calebElson.Weeker")?.value(forKey: "DOB")
    
    func weeksLivedAndLeft() -> (weeksLived: Int, weeksLeft: Int, percentLived: Int, percentLeft: Int) {
        let lifeSpan = Int(90*365.25)
        let daysLived = Calendar.current.dateComponents([.day], from: dateOfBirth as! Date, to: Date()).day!
        
        let weeksLived = daysLived/7
        // Prevents negative weeks left
        let weeksLeft = max((lifeSpan - daysLived)/7, 0)
        // Prevents above 100% life lived
        let percentLived = min(daysLived*100/lifeSpan, 100)
        let percentLeft = 100 - percentLived
        
        return (weeksLived, weeksLeft, percentLived, percentLeft)
    }
    
    func current() -> (year: Int, weekOfYear: Int) {
        let timeSinceDOB: DateComponents = Calendar.current.dateComponents([.year, .weekOfYear], from: dateOfBirth as! Date, to: Date())
        
        return (timeSinceDOB.year!, timeSinceDOB.weekOfYear!)
    }
    
    // [currentAge:lifeExpectancy]
    // Data sourced from https://www.ssa.gov/OACT/STATS/table4c6.html
    let actuarialTable = [
    0:81,
    1:82,
    2:82,
    3:82,
    4:82,
    5:82,
    6:82,
    7:82,
    8:82,
    9:82,
    10:82,
    11:82,
    12:82,
    13:82,
    14:82,
    15:82,
    16:82,
    17:82,
    18:82,
    19:82,
    20:82,
    21:82,
    22:82,
    23:82,
    24:82,
    25:82,
    26:82,
    27:82,
    28:82,
    29:82,
    30:82,
    31:82,
    32:83,
    33:83,
    34:83,
    35:83,
    36:83,
    37:83,
    38:83,
    39:83,
    40:83,
    41:83,
    42:83,
    43:83,
    44:83,
    45:83,
    46:83,
    47:83,
    48:83,
    49:84,
    50:84,
    51:84,
    52:84,
    53:84,
    54:84,
    55:84,
    56:84,
    57:85,
    58:85,
    59:85,
    60:85,
    61:85,
    62:85,
    63:85,
    64:86,
    65:86,
    66:86,
    67:86,
    68:86,
    69:87,
    70:87,
    71:87,
    72:87,
    73:88,
    74:88,
    75:88,
    76:89,
    77:89,
    78:89,
    79:90,
    80:90,
    81:91,
    82:91,
    83:91,
    84:92,
    85:92,
    86:93,
    87:93,
    88:94,
    89:95,
    90:95,
    91:96,
    92:97,
    93:97,
    94:98,
    95:99,
    96:100,
    97:100,
    98:101,
    99:102,
    100:103,
    101:104,
    102:105,
    103:105,
    104:106,
    105:107,
    106:108,
    107:109,
    108:110,
    109:111,
    110:112,
    111:113,
    112:114,
    113:114,
    114:115,
    115:116,
    116:117,
    117:118,
    118:119,
    119:120]
}
