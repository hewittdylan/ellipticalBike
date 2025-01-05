//
//  PhoneSessionManager.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 4/1/25.
//

import WatchConnectivity

struct ReceivedData {
    var heartRate: Double = 0
}

class PhoneSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = PhoneSessionManager()
    
    private override init() {}

    let session = WCSession.default

    func startSession() {
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Error al activar WCSession: \(error.localizedDescription)")
        } else {
            print("WCSession activado con estado: \(activationState.rawValue)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession se volvió inactivo.")
    }
    
    //Recibe los datos del Apple Watch
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let heartRate = message["heartRate"] as? Double {
            print("Heart Rate: \(heartRate) BPM")
            let data: ReceivedData = .init(heartRate: heartRate)
            updateBikeDataModel(data)
        }
    }

    func sessionDidDeactivate(_ session: WCSession) {
       print("WCSession desactivado.")
       session.activate() // Reactivar si es necesario.
    }
    
    private func updateBikeDataModel(_ data: ReceivedData) {
        BikeDataModel.shared.updateHeartRate(data.heartRate)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print("Datos recibidos: \(applicationContext)")
    }
}

