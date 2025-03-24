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
    @StateObject private var bleManager = BLEManager.shared
    
    @State private var playButtonIsActive: Bool = false
    @State private var stopButtonIsActive: Bool = false
    
    @State private var watchAnimation: Bool = false
    @State private var imageID: UUID = UUID()
    
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
                    HStack {
                        ZStack {
                            Circle()
                                .foregroundStyle(.gray.opacity(0.25))
                            Image(systemName: watchAnimation ? "applewatch.radiowaves.left.and.right" : "applewatch")
                                .id(imageID)
                                .font(.title)
                                .padding(.horizontal)
                                .foregroundColor(.white)
                                .scaledToFit()
                                .scaleEffect(watchAnimation ? 1.08 : 1.0)
                                .symbolEffect(.bounce, options: .repeating.speed(0.04), value: watchAnimation)
                        }
                        .frame(width: 60, height: 60)
                        .padding()
                        .onChange(of: watchConnector.watchConnected) { oldValue, newValue in
                            watchAnimation = newValue
                            if oldValue { imageID = UUID() }  //Reset image and animation
                        }
                        if watchConnector.sessionStarted && !watchAnimation {
                            ProgressView()
                        }
                    }
                }
                Spacer()
                Button(action: {
                    isMenuOpen.toggle()
                }) {
                    ZStack {
                        Circle()
                            .foregroundStyle(.gray.opacity(0.25))
                        Image(systemName: bleManager.connected ? "figure.elliptical" : "link")
                            .font(.title)
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .scaleEffect(bleManager.connected ? 1.1 : 1.0)
                            .symbolEffect(.bounce, options: .repeating.speed(0.2), value: bleManager.connected)
                    }
                    .frame(width: 60, height: 60)
                    .padding()
                }
            }
            //MARK: Stat Views
            VStack(spacing: 6) {
                HeartRateView()
                //StatView(label: "Heart Rate", value: "\(bikeData.heartRate)", unit: "bpm")
                HStack {
                    StatView(label: "Speed", value: formatDouble(bikeData.speed), unit: "km/h")
                    Spacer()
                    StatView(label: "Average Speed", value: formatDouble(bikeData.averageSpeed), unit: "km/h")
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                
                HStack {
                    StatView(label: "Cadence", value: "\(bikeData.cadence)", unit: "RPM")
                    Spacer()
                    StatView(label: "Distance", value:"\(bikeData.distance)", unit: "m")
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                
                HStack {
                    StatView(label: "Resistance", value: "\(bikeData.resistance)", unit: "")
                    Spacer()
                    StatView(label: "Power", value: formatDouble(bikeData.power), unit: "W")
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                
                HStack {
                    StatView(label: "Calories", value: "\(Int(bikeData.calories))", unit: "kcal")
                    Spacer()
                    StatView(label: "Time", value: formatTime(seconds: bikeData.elapsedTime), unit: "")
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                
                HStack(alignment: .bottom, spacing: 0) {
                    Spacer()
                    Button(action: {  // Play/Pause Button
                        if playButtonIsActive {
                            bleManager.requestPause()
                        } else {
                            bleManager.requestPlay()
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
                    Button(action: {  //Stop Button
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
            .sheet(isPresented: $isMenuOpen) {
                BluetoothPairingMenu()
            }
            .confirmationDialog("¿Seguro que quieres detener el entrenamiento?", isPresented: $stopButtonIsActive) {
                Button("Finalizar Entrenamiento") {
                    bleManager.disconnect()
                    watchConnector.sendStopWorkoutContext()
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
        }
        .frame(width: 150, height: 90)
        .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.gray.opacity(0.25)))
    }
}
