//
//  bluetooth.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 31/12/24.
//

import CoreBluetooth

//Gestion la conexión BLE
class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    static let shared = BLEManager() //Singleton
    private var centralManager: CBCentralManager!
    private var controlPoint: CBCharacteristic?
    private var connectedBike: CBPeripheral?
    
    @Published var discoveredFMSs: [CBPeripheral] = []
    @Published var connected: Bool = false
    
    private let fitnessMachineFeatureUUID = CBUUID(string: "1826")

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        discoveredFMSs.removeAll()
        centralManager.scanForPeripherals(withServices: [fitnessMachineFeatureUUID], options: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth está encendido.")
        } else {
            print("Bluetooth no está disponible.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Filtrar dispositivos sin nombre
        guard let name = peripheral.name, !name.isEmpty else {
            return
        }

        // Añadir dispositivos no duplicados
        if !discoveredFMSs.contains(peripheral) {
            discoveredFMSs.append(peripheral)
        }
    }

    func connectToBike(_ peripheral: CBPeripheral) {
        centralManager.stopScan()
        connectedBike = peripheral
        centralManager.connect(peripheral, options: nil)
        DispatchQueue.main.async {
            self.connected = true
        }
    }
    
    func isConnectedTo(_ peripheral: CBPeripheral) -> Bool {
        return connectedBike == peripheral
    }
    
    func disconnect() {
        if let peripheral = connectedBike {
            centralManager.cancelPeripheralConnection(peripheral)
        }
        connectedBike = nil
        controlPoint = nil
        connected = false
        print("Desconectado")
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
       print("Conectado a: \(peripheral.name ?? "Sin nombre")")
       peripheral.delegate = self
       peripheral.discoverServices(nil)
    }
    
    //Descubre servicios
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error al descubrir servicios: \(error.localizedDescription)")
            return
        }

        guard let services = peripheral.services else {
            print("No se encontraron servicios.")
            return
        }

        for service in services {
            print("Servicio encontrado: \(service.uuid)")

            // Descubrir características dentro del servicio
            peripheral.delegate = self // Asegúrate de que el delegado está asignado
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    //Descubre características
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error al descubrir características: \(error.localizedDescription)")
            return
        }

        guard let characteristics = service.characteristics else {
            print("No se encontraron características para el servicio \(service.uuid).")
            return
        }

        for characteristic in characteristics {
            print("Característica encontrada: \(characteristic.uuid)")

            if characteristic.uuid == CBUUID(string: "2AD9") {
                print("Fijado el Machine Control Point")
                controlPoint = characteristic
                requestControl()
                requestPause()  //Empezar en pausa
                requestReset()  //Resetear datos
            }
                
            // Si es una característica que necesitas, por ejemplo, para leer datos:
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }

            // Si es una característica que soporta notificaciones:
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    //Recibe actualizaciones de características
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error al leer el valor de la característica \(characteristic.uuid): \(error.localizedDescription)")
            return
        }

        guard let value = characteristic.value else {
            print("No se recibió ningún valor para la característica \(characteristic.uuid).")
            return
        }

        print("Valor recibido para la característica \(characteristic.uuid): \(value)")

        // Procesar el valor según la característica
        processCharacteristicValue(characteristic.uuid, value: value)
    }
    
    func requestControl() { // Request Control
        sendRequest([0x00])
        print("Control solicitado")
    }
    
    func requestReset() {  // Request Reset
        sendRequest([0x01])
        print("Reset solicitado")
    }
    
    func requestStop() {  // Request Stop
        sendRequest([0x08, 0x01])
        print("Stop solicitado")
    }
    
    func requestPause() {  // Request Pause
        sendRequest([0x08, 0x02])
        print("Pausar solicitado")
    }
    
    func requestPlay() {  // Request Play/Resume
        sendRequest([0x07])
        print("Play solcitado")
    }
    
    private func sendRequest(_ command: [UInt8]) {
        let data = Data(command)
        if let characteristic = self.controlPoint {
            self.connectedBike?.writeValue(data, for: characteristic, type: .withResponse)
        }
    }
    
    private func processCharacteristicValue(_ uuid: CBUUID, value: Data) {
        switch uuid {
        case CBUUID(string: "2AD2"): // Característica que contiene múltiples métricas
            parseIndoorBikeData(from: value)
        default:
            print("Característica no reconocida: \(uuid)")
            debugCharacteristicValue(value)
        }
    }
    
    private func debugCharacteristicValue(_ value: Data) {
        print("Datos recibidos (hex): \(value.map { String(format: "%02x", $0) }.joined(separator: " "))")
    }
    
    private func parseIndoorBikeData(from data: Data) {
        var dataModel = ReceivedData()
        //let flags = byteToInt(data, 0, 1)
        dataModel.speed = Double(byteToInt(data, 2, 3)) / 100
        dataModel.averageSpeed = Double(byteToInt(data, 4, 5)) / 100
        dataModel.cadence = byteToInt(data, 6, 7) / 2
        dataModel.averageCadence = byteToInt(data, 8, 9)
        dataModel.distance = byteToInt(data, 10, 12)
        dataModel.resistance = byteToInt(data, 13, 14)
        dataModel.power = Double(byteToInt(data, 15, 16))
        dataModel.averagePower = Double(byteToInt(data, 17, 18))
        dataModel.calories = Double(byteToInt(data, 19, 20))
        dataModel.energyPerHour = Double(byteToInt(data, 21, 22))
        dataModel.energyPerMinute = Double(byteToInt(data, 23, 23))
        dataModel.heartRate = byteToInt(data, 24, 24)
        dataModel.metabolicEquivalent = byteToInt(data, 25, 25)
        dataModel.elapsedTime = byteToInt(data, 26, 27)
        dataModel.remainingTime = byteToInt(data, 28, 29)
        BikeDataModel.shared.receiveBikeDataUpdate(dataModel)
    }
    
    private func byteToInt(_ data: Data, _ i: Int, _ j: Int) -> Int {
        return data[i...j].reversed().reduce(0) { (result, byte) in
            (result << 8) | Int(byte)
        }
    }
}
