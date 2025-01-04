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

    func sendHeartRate(_ heartRate: Double) {
        if session.isReachable {
            session.sendMessage(["heartRate": heartRate], replyHandler: nil, errorHandler: nil)
        } else {
            print("No se ha podido conectar al iPhone")
        }
    }
}
