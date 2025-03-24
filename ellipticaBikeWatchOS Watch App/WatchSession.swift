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

    func sendWatchUpdate(_ heartRate: Double, _ calories: Double) {
        guard session.isReachable else {
            print("No se ha podido enviar información al iPhone: la sesión no es alcanzable")
            return
        }
        do {
            try session.updateApplicationContext(["heartRate": heartRate, "calories": calories])
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
