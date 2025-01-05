//
//  ActivityCard.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 5/1/25.
//

import SwiftUI

struct Activity {
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let color: Color
    let amount: String
}

struct ActivityCard: View {
    @State var activity: Activity
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .cornerRadius(15)
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(activity.title)
                        Text(activity.subtitle)
                            .font(.caption)
                    }
                    Spacer()
                    Image(systemName: activity.image)
                        .foregroundColor(activity.color)
                }
                Text(activity.amount)
                    .font(.title)
                    .bold()
                    .padding(.vertical)
                    .scaledToFill()
            }
            .padding()
        }
    }
}

#Preview {
    ActivityCard(activity: Activity(id: 0, title: "Today steps", subtitle: "Goal 10.000", image: "figure.walk", color: .greenSea, amount: "70 minutes"))
}
