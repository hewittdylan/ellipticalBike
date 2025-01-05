//
//  HomeView.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 31/12/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isMenuOpen = false
    @StateObject private var watchConnector = PhoneSessionManager.shared
    
    var mockActivities = [
        Activity(id: 0, title: "Today steps", subtitle: "Goal 10000", image: "figure.walk", color: .greenSea, amount: "6742"),
        Activity(id: 1, title: "Today steps", subtitle: "Goal 10000", image: "figure.walk", color: .belizeHole, amount: "6742"),
        Activity(id: 2, title: "Today steps", subtitle: "Goal 10000", image: "figure.walk", color: .wisteria, amount: "6742"),
        Activity(id: 3, title: "Today steps", subtitle: "Goal 10000", image: "figure.walk", color: .pumpkin, amount: "6742")
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                //MARK: Connectivity Buttons
                HStack {
                    Button(action: {
                        watchConnector.startSession()
                    }) {
                        Image(systemName: "applewatch")
                            .font(.title)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .scaleEffect(1)
                    }
                    .padding()
                    Spacer()
                    Button(action: {
                        isMenuOpen.toggle()
                    }) {
                        Image(systemName: "link")
                            .font(.title)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .scaleEffect(0.8)
                    }
                    .padding()
                }
                //MARK: Stats
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        StatsView(title: "Calories", value: "155 calories", textColor: .alizarin)
                            .padding(.bottom)
                        StatsView(title: "Active", value: "47 min", textColor: .nephritis)
                            .padding(.bottom)
                        StatsView(title: "Stand", value: "8 hrs", textColor: .belizeHole)
                    }
                    Spacer()
                    ZStack {
                        ProgressCircleView(color: .alizarin, goal: 500, progress: .constant(155))
                        ProgressCircleView(color: .nephritis, goal: 60, progress: .constant(47))
                            .padding(23)
                        ProgressCircleView(color: .belizeHole, goal: 12, progress: .constant(8))
                            .padding(46)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
                
                //MARK: Activities
                HStack {
                    Text("Fitness Activity")
                        .font(.title2)
                        .bold()
                }
                .padding()
                
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                    ForEach(mockActivities, id: \.id) { activity in
                        ActivityCard(activity: activity)
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $isMenuOpen) {
            BluetoothPairingMenu()
        }
    }
}

#Preview {
    HomeView()
}

struct StatsView: View {
    var title: String
    var value: String
    var textColor: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.callout)
                .bold()
                .foregroundColor(textColor)
            Text(value)
                .bold()
        }
    }
}
