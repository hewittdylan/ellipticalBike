//
//  HealthManager.swift
//  ellipticaBikeWatchOS Watch App
//
//  Created by Dylan Hewitt on 4/1/25.
//

import HealthKit

class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    private var timer: Timer?
    @Published var heartRate: Double = 0.0
    
    private var iPhoneConnection = WatchSessionManager.shared

    func requestAuthorization() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        //let typesToShare: Set = []
        let typesToRead: Set = [heartRateType]

        healthStore.requestAuthorization(toShare: [], read: typesToRead) { (success, error) in
            if !success {
                print("Authorization failed")
            }
        }
    }

    func startHeartRateQuery() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { [weak self] _, _, error in
            if let error = error {
                print("Error starting heart rate query: \(error)")
                return
            }
            self?.fetchLatestHeartRate()
        }
        healthStore.execute(query)
    }

    private func fetchLatestHeartRate() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { [weak self] _, samples, error in
            guard let sample = samples?.first as? HKQuantitySample else { return }
            DispatchQueue.main.async {
                self?.heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
        }
        healthStore.execute(query)
    }
    
    func startPeriodicUpdates() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
                self?.fetchLatestHeartRate()
                self?.iPhoneConnection.sendHeartRate(self?.heartRate ?? 0)
                print("Nueva lectura de corazón \(self?.heartRate ?? 0)")
            }
        }
    }
    
    func stopPeriodicUpdates() {
        timer?.invalidate()
        timer = nil
    }
}

