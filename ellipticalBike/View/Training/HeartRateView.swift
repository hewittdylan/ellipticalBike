//
//  HeartRateView.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 11/1/25.
//

import SwiftUI

enum HRZones: Int, Identifiable, Equatable {
    public var id: Int {self.rawValue}
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    
    static var zones: [HRZones] {
        return [.one, .two, .three, .four, .five]
    }
    
    var color: Color {
        switch(self) {
        case .one: return .zone1
        case .two: return .zone2
        case .three: return .zone3
        case .four: return .zone4
        case .five: return .zone5
        }
    }
    
    var lowerBound: Double {
        switch(self) {
        case .one: return 0.5
        case .two: return 0.6
        case .three: return 0.7
        case .four: return 0.8
        case .five: return 0.9
        }
    }
    
    var upperBound: Double {
        switch(self) {
        case .one: return 0.59
        case .two: return 0.69
        case .three: return 0.79
        case .four: return 0.89
        case .five: return 1.0
        }
    }
}

struct HeartRateView: View {
    @ObservedObject private var bikeData = BikeDataModel.shared
    var maxHeartRate: Double = 198.0 //220 - age
    @State var currentZone: HRZones = .one
    @State var percentage: Double = 0.01
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack(spacing: -10) {
                Text("\(bikeData.heartRate)")
                    .font(Font.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundStyle(currentZone.color.opacity(0.8))
                Text("BPM")
                    .font(Font.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundStyle(currentZone.color.opacity(0.8))
                GeometryReader { proxy in
                    HStack(spacing: 4) {
                        ForEach(HRZones.zones) { zone in
                            if zone == currentZone {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(zone.color.opacity(0.8))
                                    .frame(width: proxy.size.width * 0.35)
                                    .overlay {
                                        Text("Zone \(zone.rawValue)")
                                            .font(Font.system(size: 25, weight: .heavy, design: .rounded))
                                            .foregroundStyle(.black.gradient)
                                    }
                                    .overlay {
                                        ArrowMarker(percent: percentage)
                                    }
                            } else {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(zone.color.opacity(0.2))
                            }
                        }
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 4)
                    .padding(.top, 32)
                }
            }
        }
        .onChange(of: bikeData.heartRate, { oldValue, newValue in
            currentZone = getHeartZone()
            let a = Double(bikeData.heartRate) - currentZone.lowerBound * maxHeartRate
            let b = (currentZone.upperBound - currentZone.lowerBound) * maxHeartRate
            percentage = max(a / b, 0.01)
        })
        .frame(height: 150)
        .ignoresSafeArea(.all)
    }
    
    private func getHeartZone() -> HRZones {
        for hrz in HRZones.zones {
            if Double(bikeData.heartRate) < hrz.upperBound * maxHeartRate {
                return hrz
            }
        }
        return .one
    }
}

struct ArrowMarker: Shape {
    let percent: Double
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let arrowHeight = rect.size.height * 0.15
        let xOffset = rect.width * percent
        
        path.move(to: CGPoint(x: xOffset, y: rect.maxY - arrowHeight))
        path.addLine(to: CGPoint(x: xOffset + arrowHeight, y: rect.maxY + arrowHeight))
        path.addLine(to: CGPoint(x: xOffset - arrowHeight, y: rect.maxY + arrowHeight))
        path.addLine(to: CGPoint(x: xOffset, y: rect.maxY - arrowHeight))
        
        return path
    }
}

#Preview {
    VStack {
        HeartRateView()
    }
}
