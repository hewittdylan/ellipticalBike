//
//  ContentView.swift
//  ellipticaBikeWatchOS Watch App
//
//  Created by Dylan Hewitt on 4/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var healthManager = HealthManager.shared
    private var watchSession = WatchSessionManager.shared
    
    @State private var activateSession = false
    
    var body: some View {
        ZStack {
            ZStack {
                Image(systemName: "suit.heart.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.heartRed.gradient)
                    .symbolEffect(.bounce, options: .repeating.speed(1), value: activateSession)
                    .scaleEffect(1)
                Text(String(format: "%.0f", healthManager.heartRate))
                    .font(.largeTitle)
                    .foregroundStyle(.black.gradient)
            }
            if !activateSession {
                Button(action: {
                    watchSession.startSession()
                    healthManager.requestAuthorization()
                    healthManager.startHeartRateQuery()
                    healthManager.startPeriodicUpdates()
                    activateSession = true
                    healthManager.startWorkout()
                }) {
                    VStack {
                        Text("Start")
                            .font(.title)
                            .bold()
                        Text("Heart Rate")
                            .font(.caption)
                            .foregroundStyle(.heartRed)
                        Text("Monitor")
                            .font(.caption)
                            .foregroundStyle(.heartRed)
                            
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(0)
                    .background(.black)
                    .ignoresSafeArea(.all)
                }
            }
        }
        .scaleEffect(1.5)
        .ignoresSafeArea()
        .padding()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
