//
//  TrainingView.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 3/1/25.
//

import SwiftUI

struct TrainView: View {
    @State private var isMenuOpen = false
    @StateObject private var watchConnector = PhoneSessionManager.shared
    @StateObject private var bleManager = BikeDataModel.shared.bleManager!
    
    @State private var playButtonIsActive: Bool = false
    @State private var stopButtonIsActive: Bool = false
    
    @ObservedObject private var bikeData = BikeDataModel.shared
    let horizontalPadding: CGFloat = 20
    let verticalPadding: CGFloat = 6
    
    var body: some View {
        VStack {
            //MARK: Connectivity Buttons
            HStack {
                Button(action: {
                    watchConnector.startSession()
                }) {
                    ZStack {
                        Circle()
                            .foregroundStyle(.gray.opacity(0.25))
                            .frame(width: 60, height: 60)
                        Image(systemName: "applewatch")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                    }
                }
                .padding()
                Spacer()
                Button(action: {
                    isMenuOpen.toggle()
                }) {
                    ZStack {
                        Circle()
                            .foregroundStyle(.gray.opacity(0.25))
                            .frame(width: 60, height: 60)
                        Image(systemName: "link")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
            //MARK: Stat Views
            VStack(spacing: 6) {
                StatView(label: "Heart Rate", value: "\(bikeData.heartRate)", unit: "bpm")
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
                    StatView(label: "Power", value: formatDouble(bikeData.power ?? 0), unit: "W")
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                
                HStack {
                    StatView(label: "Calories", value: formatDouble(bikeData.calories), unit: "kcal")
                    Spacer()
                    StatView(label: "Time", value: formatTime(seconds: bikeData.time ?? 0), unit: "")
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                
                HStack(alignment: .bottom, spacing: 0) {
                    Spacer()
                    Button(action: {
                        if playButtonIsActive {
                            bleManager.requestPlay()
                        } else {
                            bleManager.requestPause()
                        }
                        playButtonIsActive.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(.gray.opacity(0.25))
                                .frame(width: 60, height: 60)
                            Image(systemName: playButtonIsActive ? "pause" :"play")
                                .font(.title)
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    Spacer(minLength: 125)
                    Button(action: {
                        stopButtonIsActive = true
                        if playButtonIsActive {
                            bleManager.requestPause()
                        }
                        playButtonIsActive = false
                    }) {
                        ZStack {
                            Circle()
                                .fill(.gray.opacity(0.25))
                                .frame(width: 60, height: 60)
                            Image(systemName: "stop")
                                .font(.title)
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .padding(5)
                
                Spacer()
            }
            .frame(alignment: .top)
            .sheet(isPresented: $isMenuOpen, onDismiss: {
                bleManager.requestReset()
            }) {
                BluetoothPairingMenu()
            }
            .confirmationDialog("¿Seguro que quieres detener el entrenamiento?", isPresented: $stopButtonIsActive) {
                Button("Detener") {
                    print("Detener entrenamiento")
                    bleManager.requestStop()
                }
                Button("Cancelar") {
                    
                }
            }
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
        ZStack {
            VStack(alignment: .center, spacing: 5) {
                Text(label)
                    .font(.headline)
                    .foregroundColor(.white)
                HStack {
                    Text(value)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(unit)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            if label == "Heart Rate" && BikeDataModel.shared.watchConnected {
                Image(systemName: "applewatch.radiowaves.left.and.right")
                    .frame(width: 138, alignment: .leading)
            }
        }
        .frame(width: 150, height: 90)
        .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.gray.opacity(0.25)))
    }
}
