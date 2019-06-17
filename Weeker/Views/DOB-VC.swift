//
//  DOB-VC.swift
//  Weeker
//
//  Created by Caleb Elson on 6/17/19.
//  Copyright © 2019 Caleb Elson. All rights reserved.
//

import SwiftUI

struct DOB_VC : View {
    @EnvironmentObject var userData: UserData
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        return formatter
    }
    
    private let mainColor = UIColor(named: "mainColor") ?? .systemTeal
    private let secondaryColor = UIColor(named: "secondaryColor") ?? UIColor.systemOrange
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Toggle(isOn: $userData.actuarialLifeSpan) {
                        Text("Switch to actuarial lifespan")
                    }
                    .padding()
                    

                    Text("Default lifespan is 90 years")
                        .font(.caption)
                }
                Spacer()
                Text("Select date of birth")
                .font(.headline)
                DatePicker($userData.dateOfBirth, minimumDate: dateFormatter.date(from: "1900-01-01"), maximumDate: Date(), displayedComponents: .date)
                Spacer()
            }
        }
    }
}

#if DEBUG
struct DOB_VC_Previews : PreviewProvider {
    static var previews: some View {
        DOB_VC()
        .environmentObject(UserData())
    }
}
#endif
