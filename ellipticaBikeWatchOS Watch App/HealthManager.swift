//
//  HealthManager.swift
//  ellipticaBikeWatchOS Watch App
//
//  Created by Dylan Hewitt on 4/1/25.
//

import HealthKit

class HealthManager: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    static let shared = HealthManager()
    
    let healthStore = HKHealthStore()
    private var timer: Timer?
    @Published var heartRate: Double = 0.0
    
    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?
    
    // MARK: - HKWorkoutSessionDelegate
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            print("Sesión de entrenamiento iniciada.")
        case .ended:
            print("Sesión de entrenamiento terminada.")
        default:
            print("Estado de sesión: \(toState.rawValue)")
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Error en la sesión de entrenamiento: \(error.localizedDescription)")
    }

    // MARK: - HKLiveWorkoutBuilderDelegate
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        print("Se ha recopilado un evento de entrenamiento.")
    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf types: Set<HKSampleType>) {
        // Aquí puedes manejar los datos recopilados en tiempo real
        print("Datos recopilados: \(types)")
    }
    
    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .elliptical
        configuration.locationType = .indoor
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()
            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

            workoutSession?.delegate = self
            workoutBuilder?.delegate = self

            workoutSession?.startActivity(with: Date())
            workoutBuilder?.beginCollection(withStart: Date()) { success, error in
                if !success {
                    print("Error al iniciar el workout: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        } catch {
            print("Error al configurar la sesión de ejercicio: \(error.localizedDescription)")
        }
    }
    
    func stopWorkout() {
        workoutSession?.end()
        workoutBuilder?.endCollection(withEnd: Date()) { success, error in
            if !success {
                print("Error al finalizar el workout: \(error?.localizedDescription ?? "Unknown error")")
            }
            self.workoutBuilder?.finishWorkout { workout, error in
                if let error = error {
                    print("Error al finalizar el entrenamiento: \(error.localizedDescription)")
                } else {
                    print("Entrenamiento finalizado correctamente.")
                }
            }
        }
    }

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
                WatchSessionManager.shared.sendHeartRate(self?.heartRate ?? 0)
                print("Nueva lectura de corazón \(self?.heartRate ?? 0)")
            }
        }
    }
    
    func stopPeriodicUpdates() {
        timer?.invalidate()
        timer = nil
    }
}

