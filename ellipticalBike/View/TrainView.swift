//
//  TrainView.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 2/1/25.
//

import SwiftUI

struct TrainView: View {
    @ObservedObject private var bikeData = BLEManager.shared.dataModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Title
            Text("Bike Data")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Data grid
            Grid {
                GridRow(label: "Speed", value: "\(bikeData.speed ?? 0) km/h").background(Color.red)
                GridRow(label: "Average Speed", value: "\(bikeData.averageSpeed ?? 0) km/h")
                GridRow(label: "Cadence", value: "\(bikeData.cadence ?? 0) RPM").background(Color.red)
                GridRow(label: "Average Cadence", value: "\(bikeData.averageCadence ?? 0) RPM").background(Color.red)
                GridRow(label: "Distance", value: "\(bikeData.distance ?? 0) m")
                GridRow(label: "Resistance", value: "\(bikeData.resistance ?? 0)")
                GridRow(label: "Power", value: "\(bikeData.power ?? 0) W").background(Color.red)
                GridRow(label: "Calories", value: "\(bikeData.calories ?? 0) kcal")
                GridRow(label: "Heart Rate", value: "\(bikeData.heartRate ?? 0) BPM").background(Color.red)
                GridRow(label: "Time", value: formatTime(seconds: bikeData.time ?? 0))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .frame(alignment: .top)
    }
    
    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct GridRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TrainView()
}

