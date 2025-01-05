//
//  WokoutCard.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 5/1/25.
//

import SwiftUI

struct WorkoutCardData {
    let id: Int
    let title: String
    let image: String
    let color: Color
    let duration: String
    let date: String
    let calories: Int
}

struct WorkoutCard: View {
    @State var workoutData: WorkoutCardData
    var body: some View {
        HStack {
            Image(systemName: workoutData.image)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundStyle(workoutData.color)
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack {
                HStack {
                    Text(workoutData.title)
                        .font(.title3)
                        .bold()
                    Spacer()
                    Text(workoutData.duration)
                }
                
                HStack {
                    Text(workoutData.date)
                    Spacer()
                    Text("\(workoutData.calories) kcal")
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    WorkoutCard(workoutData: WorkoutCardData(id: 0, title: "Running", image: "figure.elliptical", color: .greenSea, duration: "37 minutes", date: "Friday", calories: 320))
}
