//
//  TrainingView.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 3/1/25.
//

import SwiftUI

struct TrainView: View {
    @ObservedObject private var bikeData = BLEManager.shared.dataModel
    let horizontalPadding: CGFloat = 20
    let verticalPadding: CGFloat = 6
    
    var body: some View {
        NavigationStack {
            LazyVStack(spacing: 6) {
                HStack {
                    StatView(label: "Speed", value: formatDouble(bikeData.speed ?? 0.0), unit: "km/h")
                    Spacer()
                    StatView(label: "Average Speed", value: formatDouble(bikeData.averageSpeed), unit: "km/h")
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                
                HStack {
                    StatView(label: "Cadence", value: "\(bikeData.cadence ?? 0)", unit: "RPM")
                    Spacer()
                    StatView(label: "Distance", value:"\(bikeData.distance ?? 0)", unit: "m")
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                
                HStack {
                    StatView(label: "Resistance", value: "\(bikeData.resistance ?? 0)", unit: "")
                    Spacer()
                    StatView(label: "Power", value:"\(bikeData.power ?? 0)", unit: "W")
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                
                HStack {
                    StatView(label: "Calories", value: "\(bikeData.calories ?? 0)", unit: "kcal")
                    Spacer()
                    StatView(label: "Time", value: formatTime(seconds: bikeData.time ?? 0), unit: "")
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                
                HStack(alignment: .bottom, spacing: 15) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "play")
                            .font(.title)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .scaleEffect(0.8)
                    }
                    .padding()
                }
                
            }
            .padding(10)
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
    TrainView()
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
        .frame(width: 140, height: 115)
        .background(RoundedRectangle(cornerRadius: 30).stroke(.black, lineWidth: 3.5))
    }
}
