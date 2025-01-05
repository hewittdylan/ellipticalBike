//
//  HomeView.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 31/12/24.
//

import SwiftUI

struct HomeView: View {
    var mockActivities = [
        Activity(id: 0, title: "Today steps", subtitle: "Goal 10.000", image: "figure.walk", color: .greenSea, amount: "6.742"),
        Activity(id: 1, title: "Today calories", subtitle: "Goal 500", image: "flame.fill", color: .alizarin, amount: "155 kcal"),
        Activity(id: 2, title: "Running", subtitle: "This week", image: "figure.elliptical", color: .wisteria, amount: "70 minutes"),
        Activity(id: 3, title: "Today distance", subtitle: "Goal 5 km", image: "figure.walk", color: .pumpkin, amount: "4.2 km")
    ]
    
    var mockWorkouts = [
        WorkoutCardData(id: 0, title: "Running", image: "figure.elliptical", color: .greenSea, duration: "37 minutes", date: "Saturday", calories: 420),
        WorkoutCardData(id: 1, title: "Running", image: "figure.elliptical", color: .greenSea, duration: "15 minutes", date: "Friday", calories: 176),
        WorkoutCardData(id: 2, title: "Running", image: "figure.elliptical", color: .greenSea, duration: "23 minutes", date: "Friday", calories: 240)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
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
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(activity.color, lineWidth: 2)
                                }
                        }
                    }
                    .padding(.horizontal)
                    
                    //MARK: Last Workouts
                    HStack {
                        Text("Last Workouts")
                            .font(.title2)
                            .bold()
                    }
                    .padding()
                    
                    LazyVStack {
                        ForEach(mockWorkouts, id: \.id) { workout in
                            WorkoutCard(workoutData: workout)
                        }
                    }
                }
            }
            .navigationTitle("Summary")
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
