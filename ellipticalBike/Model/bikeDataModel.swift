//
//  bikeDataModel.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 31/12/24.
//

import Foundation

class BikeDataModel: ObservableObject {
    @Published var speed: Int?
    @Published var averageSpeed: Int?
    @Published var cadence: Int?
    @Published var averageCadence: Int?
    @Published var distance: Int?
    @Published var resistance: Int?
    @Published var power: Int?
    @Published var calories: Int?
    @Published var heartRate: Int?
    @Published var time: Int?
    @Published var remainingTime: Int?
    
    init(speed: Int? = nil, averageSpeed: Int? = nil, cadence: Int? = nil, averageCadence: Int? = nil, distance: Int? = nil, resistance: Int? = nil, power: Int? = nil, calories: Int? = nil, heartRate: Int? = nil, time: Int? = nil, remainingTime: Int? = nil) {
        self.speed = speed
        self.averageSpeed = averageSpeed
        self.cadence = cadence
        self.averageCadence = averageCadence
        self.distance = distance
        self.resistance = resistance
        self.power = power
        self.calories = calories
        self.heartRate = heartRate
        self.time = time
        self.remainingTime = remainingTime
    }
}

