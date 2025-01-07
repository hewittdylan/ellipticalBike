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
    @Published var watchConnected: Bool = false
    
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
    var machineCalories: Double = 0.0
    var watchCalories: Double = 0.0
    var calories: Double {  //Prioridad a las calorias con un sensor más preciso
        if watchConnected {
            return watchCalories
        } else {
            return machineCalories
        }
    }
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
        DispatchQueue.main.async {
            self.watchConnected = true
            //Updated every 3 seconds at most
            self.heartRate = Int(heartRate)
        }
        watchCalories += calculateCaloriesPerMinute(heartRate: heartRate, age: 22, weight: 80, isMale: true) / 12
        //Dividir por 12, pues se actualiza cada 5 segundos
    }
    
    private func calculateCaloriesPerMinute(heartRate: Double, age: Int, weight: Double, isMale: Bool) -> Double {
        let sexFactor = isMale ? 1.0 : 0.0
        return (heartRate * 0.6309 - Double(age) * 0.2017 + weight * 0.09036 + sexFactor * 1.9 - 55.0969) / 4.184
    }
}

