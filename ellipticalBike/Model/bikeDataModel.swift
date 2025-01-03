//
//  bikeDataModel.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 31/12/24.
//

import Foundation

class BikeDataModel: ObservableObject {
    @Published var speed: Double?
    var averageSpeed: Double {
        if let distance = self.distance, let time = self.time, time > 0 {
            return (Double(distance) / Double(time)) * 3.6
        } else {
            return 0.0
        }
    }
    @Published var cadence: Int?
    @Published var distance: Int?
    @Published var resistance: Int?
    @Published var power: Double?
    @Published var calories: Int?
    @Published var heartRate: Int?
    @Published var time: Int?
    
    init(speed: Double? = nil, cadence: Int? = nil, distance: Int? = nil, resistance: Int? = nil, power: Double? = nil, calories: Int? = nil, heartRate: Int? = nil, time: Int? = nil) {
        self.speed = speed
        self.cadence = cadence
        self.distance = distance
        self.resistance = resistance
        self.power = power
        self.calories = calories
        self.heartRate = heartRate
        self.time = time
    }
}

