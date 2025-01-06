//
//  CircleStatsView.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 6/1/25.
//

import SwiftUI

struct CircleStatsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Activity Rings")
                .font(.title3)
                .bold()
                .padding(.horizontal)
                .padding(.top, 10)
            Rectangle()
                .fill(.gray.opacity(0.25))
                .frame(height: 1)
            HStack(spacing: 10) {
                ZStack {
                    ProgressCircleView(color: .ringRed, goal: 500, progress: .constant(155))
                    ProgressCircleView(color: .ringGreen, goal: 60, progress: .constant(47))
                        .padding(23)
                    ProgressCircleView(color: .ringBlue, goal: 12, progress: .constant(8))
                        .padding(46)
                }
                .frame(width: 160, height: 180, alignment: .center)
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    StatsView(title: "Move", value: "155/500 KCAL", textColor: .ringRed)
                        .padding(.bottom, 5)
                    StatsView(title: "Exercise", value: "47/60 MIN", textColor: .ringGreen)
                        .padding(.bottom, 5)
                    StatsView(title: "Stand", value: "8/10 HRS", textColor: .ringBlue)
                }
                .frame(width: 160, height: 180, alignment: .center)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding(.horizontal)
        }
        .background(.gray.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

#Preview {
    CircleStatsView()
}

struct StatsView: View {
    var title: String
    var value: String
    var textColor: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.title3)
                .bold()
            Text(value)
                .font(.title2)
                .bold()
                .foregroundStyle(textColor)
        }
    }
}
