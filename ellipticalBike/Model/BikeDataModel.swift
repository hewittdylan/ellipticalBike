//
//  bikeDataModel.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 31/12/24.
//

import Foundation

class BikeDataModel: ObservableObject {
    static let shared = BikeDataModel() //Singleton
    var bleManager: BLEManager?
    
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
    @Published var calories: Double = 0.0
    @Published var heartRate: Int = 0
    @Published var time: Int?
    
    init(speed: Double? = nil, cadence: Int? = nil, distance: Int? = nil, resistance: Int? = nil, power: Double? = nil, time: Int? = nil) {
        self.speed = speed
        self.cadence = cadence
        self.distance = distance
        self.resistance = resistance
        self.power = power
        self.time = time
        self.bleManager = BLEManager(bikeDataModel: self)
    }
    
    func updateHeartRate(_ heartRate: Double) {
        //Updated every 3 seconds at most
        self.heartRate = Int(heartRate)
        calculateCalories(heartRate: heartRate, age: 22, weight: 80, isMale: true)
        
    }
    
    private func calculateCalories(heartRate: Double, age: Int, weight: Double, isMale: Bool) {
        let sexFactor = isMale ? 1.0 : 0.0
        let caloriesPerMinute = (heartRate * 0.6309 - Double(age) * 0.2017 + weight * 0.09036 + sexFactor * 1.9 - 55.0969) / 4.184
        calories += caloriesPerMinute / 20
        //Dividir por 20, pues se actualiza cada 3 segundos
    }
}

