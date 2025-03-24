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
    private var watchCaloriesSum = 0.0
    
    @Published var speed: Double = 0
    @Published var averageSpeed: Double = 0
    @Published var cadence: Int = 0
    @Published var averageCadence: Int = 0
    @Published var distance: Int = 0
    @Published var resistance: Int = 0
    @Published var power: Double = 0
    @Published var averagePower: Double = 0
    @Published var calories: Double = 0
    @Published var energyPerHour: Double = 0
    @Published var energyPerMinute: Double = 0
    @Published var heartRate: Int = 0
    @Published var metabolicEquivalent: Int = 0
    @Published var elapsedTime: Int = 0
    @Published var remainingTime: Int = 0
    
    func receiveWatchUpdate(_ data: ReceivedData) {
        if let hr = data.heartRate {
            DispatchQueue.main.async {
                self.heartRate = hr
            }
        }
        if let cl = data.calories {
            DispatchQueue.main.async {
                self.calories = cl.rounded(.down)
            }
        }
    }
    
    /*
    private func calculateCaloriesPerMinute(heartRate: Int, age: Int, weight: Double, isMale: Bool) -> Double {
        var calories: Double
        if isMale {  //Keytel Formula
            calories = Double(age) * 0.2017 + weight * 0.1988 + Double(heartRate) * 0.6309 - 55.0969
        } else {
            calories = Double(age) * 0.074 - weight * 0.1263 + Double(heartRate) * 0.4472 - 20.4022
        }
        return max(calories / 4.184, 0.0)
    }
    */
    
    func receiveBikeDataUpdate(_ data: ReceivedData) {
        DispatchQueue.main.async {
            if let s = data.speed {
                self.speed = s
            }  //Average speed may need distance and time info, later on...
            if let c = data.cadence {
                self.cadence = c
            }
            if let ac = data.averageCadence {
                self.averageCadence = ac
            }
            if let d = data.distance {
                self.distance = d
            }
            if let r = data.resistance {
                self.resistance = r
            }
            if let p = data.power {
                self.power = p
            }
            if let ap = data.averagePower {
                self.averagePower = ap
            }
            if let eph = data.energyPerHour {
                self.energyPerHour = eph
            }
            if let epm = data.energyPerMinute {
                self.energyPerMinute = epm
            }
            if !PhoneSessionManager.shared.watchConnected {  //Si hay un Apple Watch conectado tiene prioridad
                if let c = data.calories {
                    self.calories = c
                }
                if let hr = data.heartRate {
                    self.heartRate = hr
                }
            }
            if let me = data.metabolicEquivalent {
                self.metabolicEquivalent = me
            }
            if let et = data.elapsedTime {
                self.elapsedTime = et
            }
            if let rt = data.remainingTime {
                self.remainingTime = rt
            }
            if self.elapsedTime == 0 {
                self.averageSpeed = 0
            } else {
                self.averageSpeed = (Double(self.distance) / Double(self.elapsedTime)) * 3.6
            }
        }
    }
}

struct ReceivedData {
    var speed: Double? = nil
    var averageSpeed: Double? = nil
    var cadence: Int? = nil
    var averageCadence: Int? = nil
    var distance: Int? = nil
    var resistance: Int? = nil
    var power: Double? = nil
    var averagePower: Double? = nil
    var calories: Double? = nil
    var energyPerHour: Double? = nil
    var energyPerMinute: Double? = nil
    var heartRate: Int? = nil
    var metabolicEquivalent: Int? = nil
    var elapsedTime: Int? = nil
    var remainingTime: Int? = nil
}
