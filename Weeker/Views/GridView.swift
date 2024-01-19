//
//  GridView.swift
//  Weeker
//
//  Created by Caleb Elson on 1/16/24.
//  Copyright © 2024 Caleb Elson. All rights reserved.
//

import SwiftUI

struct SquareGridView: View {
    // Placeholders until integrating with DOB model
    let years = 80
    let weeks = 52
    let emptyThreshold = 256
    
    let spacing: CGFloat = 1
    let horizontalPadding: CGFloat = 16
    let margins: CGFloat = 10

    var body: some View {
        GeometryReader { geometry in
            let totalPadding = self.spacing*CGFloat(self.weeks) + self.horizontalPadding + (2 * self.margins)
            let squareSize = (geometry.size.width - totalPadding) / CGFloat(self.weeks)

            VStack(spacing: self.spacing) {
                ForEach(0..<self.years, id: \.self) { year in
                    HStack(spacing: self.spacing) {
                        ForEach(0..<self.weeks, id: \.self) { week in
                            Rectangle()
                                .frame(width: squareSize, height: squareSize)
                                .foregroundColor(year * self.weeks + week < self.emptyThreshold ? .blue : .clear)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.blue, lineWidth: year * self.weeks + week >= self.emptyThreshold ? 1 : 0)
                                )
                        }
                    }
                    .padding(.bottom, self.spacing)
                }
            }
            // Center the grid
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    SquareGridView()
}
