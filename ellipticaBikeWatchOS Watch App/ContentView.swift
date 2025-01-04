//
//  ContentView.swift
//  ellipticaBikeWatchOS Watch App
//
//  Created by Dylan Hewitt on 4/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var healthManager = HealthManager()
    
    var body: some View {
        ZStack {
            Image(systemName: "heart")
                .imageScale(.large)
                .foregroundStyle(.red)
                .scaleEffect(7)
            Text(String(format: "%.0f", healthManager.heartRate))
                .font(.largeTitle)
                .scaleEffect(1.3)
        }
        .padding()
        .onAppear {
            healthManager.requestAuthorization()
            healthManager.startHeartRateQuery()
            healthManager.startPeriodicUpdates()
        }
    }
}

#Preview {
    ContentView()
}
