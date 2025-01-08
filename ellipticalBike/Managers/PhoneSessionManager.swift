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
    private var timer: Timer?
    
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
            receivedData.heartRate = Int(heartRate)
            BikeDataModel.shared.receiveWatchUpdate(receivedData)
            setWatchConnected(value: true)
            timeConnection()
        }
    }
    
    private func timeConnection() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: (2 * watchRefreshingInterval), repeats: false) { _ in
            self.setWatchConnected(value: false)
        }
    }
    
    private func setWatchConnected(value: Bool) {
        DispatchQueue.main.async {
            self.watchConnected = value
        }
    }

    func sessionDidDeactivate(_ session: WCSession) {
       print("WCSession desactivado.")
       session.activate() // Reactivar si es necesario.
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print("Datos recibidos: \(applicationContext)")
    }
}

