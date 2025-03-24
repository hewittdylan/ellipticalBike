//
//  PhoneSessionManager.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 4/1/25.
//

import WatchConnectivity

class PhoneSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = PhoneSessionManager() //Singleton
    private var receivedData: ReceivedData = ReceivedData()
    
    @Published var watchConnected: Bool = false
    @Published var sessionStarted: Bool = false
    private var timer: Timer?
    
    private override init() {}

    let session = WCSession.default

    func startSession() {
        session.delegate = self
        session.activate()
        sessionStarted = true
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Error al activar WCSession: \(error.localizedDescription)")
        } else {
            print("WCSession activado con estado: \(activationState.rawValue)")
        }
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Session did deactivate")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession se volvió inactivo.")
    }
    
    //Recibe datos del Apple Watch
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        if let heartRate = applicationContext["heartRate"] as? Double,
           let calories = applicationContext["calories"] as? Double {
            print("Pulsaciones: \(heartRate) BPM")
            receivedData.heartRate = Int(heartRate)
            print("Calorias: \(calories)")
            receivedData.calories = calories
            BikeDataModel.shared.receiveWatchUpdate(receivedData)
            DispatchQueue.main.async {
                self.watchConnected = true
            }
            timeConnection()
        }
        
    }
    
    private func timeConnection() {
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 2 * watchRefreshingInterval, repeats: false) { [weak self] _ in
                print("Timer fired")
                self?.watchConnected = false
            }
        }
    }
    
    func sendStopWorkoutContext() {
        do {
            try session.updateApplicationContext(["action": "stopWorkout"])
            print("Contexto actualizado para detener el entrenamiento")
        } catch {
            print("Error al actualizar ApplicationContext: \(error.localizedDescription)")
        }
    }
}

