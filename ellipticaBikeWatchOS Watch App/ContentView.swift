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
    @State private var showPulses = false
    @State private var pulsedHearts: [HeartParticle] = []
    
    var body: some View {
        ZStack {
            if showPulses {
                TimelineView(.animation(minimumInterval: 0.7, paused: false)) { timeline in
                    Canvas { context, size in
                        for heart in pulsedHearts {
                            if let resolvedView = context.resolveSymbol(id: heart.id) {
                                let centerX = size.width / 2
                                let centerY = size.height / 2
                                
                                context.draw(resolvedView, at: CGPoint(x: centerX, y: centerY))
                            }
                        }
                    } symbols: {
                        ForEach(pulsedHearts) {
                            PulseHeartView()
                                .id($0.id)
                                .scaleEffect(0.85)
                                .scaledToFit()
                        }
                    }
                    .onChange(of: timeline.date) { oldValue, newValue in
                        let pulsedHeart = HeartParticle()
                        pulsedHearts.append(pulsedHeart)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            pulsedHearts.removeAll(where: {$0.id == pulsedHeart.id})
                        }
                    }
                }
                .ignoresSafeArea()
            }
            Image(systemName: "suit.heart.fill")
                .font(.system(size: 100))
                .foregroundStyle(.red.gradient)
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
            showPulses = true
        }
        .preferredColorScheme(.dark)
        
    }
}

#Preview {
    ContentView()
}

struct PulseHeartView: View {
    @State private var startAnimation: Bool = false
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .font(.system(size: 100))
            .foregroundStyle(.red)
            .scaleEffect(startAnimation ? 2 : 1)
            .opacity(startAnimation ? 0 : 0.7)
            .onAppear(perform: {
                withAnimation(.linear(duration: 3)) {
                    startAnimation = true
                }
            })
    }
}

struct HeartParticle: Identifiable {
    var id: UUID = .init()
}
