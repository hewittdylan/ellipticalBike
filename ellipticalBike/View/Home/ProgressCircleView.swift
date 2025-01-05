//
//  ProgressCircleView.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 5/1/25.
//

import SwiftUI

struct ProgressCircleView: View {
    var color: Color
    var goal: Int
    @Binding var progress: Int
    let width = CGFloat(20)
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.5), lineWidth: width)
            Circle()
                .trim(from: 0, to: CGFloat(progress) / CGFloat(goal))
                .stroke(color, style: StrokeStyle(lineWidth: width, lineCap: .round))
                .rotationEffect(.degrees(270))
                .shadow(radius: 5)
        }
    }
}

#Preview {
    ProgressCircleView(color: .alizarin, goal: 500, progress: .constant(155))
}
