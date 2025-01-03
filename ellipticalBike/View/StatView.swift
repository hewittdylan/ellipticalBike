//
//  StatView.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 31/12/24.
//

import SwiftUI

struct StatView: View {
    var label: String
    var value: String
    var unit: String

    var body: some View {
        VStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.gray)
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(unit)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cornerRadius(10)
    }
}

#Preview {
    StatView(label: "Velocidad", value: "0", unit: "km/h")
}
