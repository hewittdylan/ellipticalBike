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
    
    @State private var activeSession = false
    @State private var activeWorkout = false
    
    var body: some View {
        ZStack {
            Button(action: {
                if activeWorkout {
                    healthManager.stopWorkout()
                } else {
                    if !activeSession {
                        activeSession = true
                        watchSession.startSession()  //Se activa una única vez, no se desactiva
                        healthManager.requestAuthorization()
                        healthManager.startHeartRateQuery()
                    }
                    healthManager.startWorkout()
                }
                activeWorkout.toggle()
            }) {
                if !activeWorkout {
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
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(width: 250, height: 250, alignment: .center)
                    .padding()
                    .background(.black)
                } else {
                    VStack(alignment: .center,spacing: -60) {
                        ZStack {
                            Image(systemName: "suit.heart.fill")
                                .font(.system(size: 100))
                                .foregroundStyle(.heartRed.gradient)
                                .symbolEffect(.bounce, options: .repeating.speed(1), value: activeWorkout)
                                .scaleEffect(1)
                            Text(String(format: "%.0f", healthManager.heartRate))
                                .font(.largeTitle)
                                .foregroundStyle(.black.gradient)
                        }
                        .scaleEffect(1.5)
                        .frame(width: 250, height: 250, alignment: .center)
                        .background(.black)
                        HStack {
                            Text(String(format: "%.0f", healthManager.calories))
                                .font(.title)
                                .foregroundStyle(.white.gradient)
                                .frame(width: 50, height: 50, alignment: .center)
                            Text("kcal")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.60))
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
