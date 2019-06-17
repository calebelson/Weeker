//
//  UserData.swift
//  Weeker
//
//  Created by Caleb Elson on 6/17/19.
//  Copyright © 2019 Caleb Elson. All rights reserved.
//

import SwiftUI
import Combine

final class UserData: BindableObject {
    let didChange = PassthroughSubject<UserData, Never>()
    
    var actuarialLifeSpan = false {
        didSet {
            didChange.send(self)
        }
    }
    
    var dateOfBirth = Date() {
        didSet {
            didChange.send(self)
        }
    }
    
}
