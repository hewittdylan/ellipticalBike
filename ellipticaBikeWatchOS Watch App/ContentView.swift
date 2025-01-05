//
//  ContentView.swift
//  ellipticaBikeWatchOS Watch App
//
//  Created by Dylan Hewitt on 4/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var healthManager = HealthManager()
    private var watchSession = WatchSessionManager.shared
    
    @State private var beatAnimation = false
    
    var body: some View {
        ZStack {
            Image(systemName: "suit.heart.fill")
                .font(.system(size: 100))
                .foregroundStyle(.strongRed.gradient)
                .symbolEffect(.bounce, options: .repeating.speed(1), value: beatAnimation)
                .scaleEffect(1)
            Text(String(format: "%.0f", healthManager.heartRate))
                .font(.largeTitle)
                .foregroundStyle(.black.gradient)
        }
        .scaleEffect(1.4)
        .ignoresSafeArea()
        .padding()
        .onAppear {
            watchSession.startSession()
            healthManager.requestAuthorization()
            healthManager.startHeartRateQuery()
            healthManager.startPeriodicUpdates()
            beatAnimation = true
        }
        .preferredColorScheme(.dark)
        
    }
}

#Preview {
    ContentView()
}
