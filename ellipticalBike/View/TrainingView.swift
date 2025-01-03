//
//  TrainingView.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 3/1/25.
//

import SwiftUI

struct TrainingView: View {
    @ObservedObject private var bikeData = BLEManager.shared.dataModel
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 6) {
                    HStack {
                        StatView(label: "Speed", value: formatDouble(bikeData.speed ?? 0.0), unit: "km/h")
                        Spacer()
                        StatView(label: "Average Speed", value: formatDouble(bikeData.averageSpeed), unit: "km/h")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    HStack {
                        StatView(label: "Cadence", value: "\(bikeData.cadence ?? 0)", unit: "RPM")
                        Spacer()
                        StatView(label: "Distance", value:"\(bikeData.distance ?? 0)", unit: "m")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    HStack {
                        StatView(label: "Resistance", value: "\(bikeData.resistance ?? 0)", unit: "")
                        Spacer()
                        StatView(label: "Power", value:"\(bikeData.power ?? 0)", unit: "W")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    HStack {
                        StatView(label: "Calories", value: "\(bikeData.calories ?? 0)", unit: "kcal")
                        Spacer()
                        StatView(label: "Time", value: formatTime(seconds: bikeData.time ?? 0), unit: "")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                }
                .padding(10)
            }
            .navigationTitle("Training Metrics")
        }
    }
    
    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func formatDouble(_ value: Double) -> String {
            return String(format: "%.1f", value)
    }
}

#Preview {
    TrainingView()
}

struct StatView: View {
    var label: String
    var value: String
    var unit: String

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(label)
                .font(.headline)
                .foregroundColor(.black)
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(unit)
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.9))
        }
        .frame(width: 150, height: 140)
        .background(RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 5))
    }
}
