//
//  WatchSessionManager.swift
//  ellipticaBikeWatchOS Watch App
//
//  Created by Dylan Hewitt on 4/1/25.
//

import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchSessionManager()
    
    private override init() {}

    let session = WCSession.default

    func startSession() {
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Error en la activación de la sesión: \(error.localizedDescription)")
        } else {
            print("WCSession activado con estado: \(activationState.rawValue)")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        if let action = applicationContext["action"] as? String, action == "stopWorkout" {
            DispatchQueue.main.async {
                HealthManager.shared.stopWorkout()
            }
        }
    }


    func sendHeartRate(_ heartRate: Double) {
        do {
            try session.updateApplicationContext(["heartRate": heartRate])
        } catch {
            print("Error al actualizar ApplicationContext: \(error.localizedDescription)")
        }
    }

    func updateData(data: [String: Any]) {
        do {
            try session.updateApplicationContext(data)
        } catch {
            print("Error al enviar contexto de la aplicación: \(error)")
        }
    }
}
