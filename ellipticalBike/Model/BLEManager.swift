//
//  bluetooth.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 31/12/24.
//

import CoreBluetooth

//Gestion la conexión BLE
class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    private var centralManager: CBCentralManager!
    
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var connectedBike: CBPeripheral?
    @Published var dataModel: BikeDataModel

    init(bikeDataModel: BikeDataModel) {
        self.dataModel = bikeDataModel
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        discoveredDevices.removeAll()
        centralManager.scanForPeripherals(withServices: nil)
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
        if !discoveredDevices.contains(peripheral) {
            discoveredDevices.append(peripheral)
        }
    }

    func connectToBike(_ peripheral: CBPeripheral) {
       centralManager.stopScan()
       connectedBike = peripheral
       centralManager.connect(peripheral, options: nil)
    }
    
    func disconnect() {
        if let peripheral = connectedBike {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
       print("Conectado a: \(peripheral.name ?? "Sin nombre")")
       peripheral.delegate = self
       peripheral.discoverServices(nil)
    }
    
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
    
    func processCharacteristicValue(_ uuid: CBUUID, value: Data) {
        switch uuid {
        case CBUUID(string: "2AD2"): // Característica que contiene múltiples métricas
            parseIndoorBikeData(from: value)
        default:
            print("Característica no reconocida: \(uuid)")
            debugCharacteristicValue(value)
        }
    }
    
    func debugCharacteristicValue(_ value: Data) {
        print("Datos recibidos (hex): \(value.map { String(format: "%02x", $0) }.joined(separator: " "))")
    }
    
    func parseIndoorBikeData(from data: Data) {
        guard data.count >= 4 else {
            print("Error: Los datos son demasiado cortos para contener los campos requeridos.")
            return
        }
        
        //debugCharacteristicValue(data)
        
        //let flags = byteToInt(data, 0, 1)
        dataModel.speed = Double(byteToInt(data, 2, 3)) / 100                //OK
        //let averageSpeed = byteToInt(data, 4, 5) * 0.036
        dataModel.cadence = byteToInt(data, 6, 7) / 2                        //OK
        //let averageCadence = byteToInt(data, 8, 9)
        dataModel.distance = byteToInt(data, 10, 11) / 10 * 10 //Round       //OK
        //let instantaneousPower = byteToInt(data, 10, 11)
        //let totalEnergy = byteToInt(data, 12, 13)
        dataModel.resistance = byteToInt(data, 13, 13)                       //OK
        dataModel.power = Double(byteToInt(data, 14, 15)) / 360              //OK
        //let energyPerMinute = byteToInt(data, 16, 17) KJ
        //dataModel.calories = byteToInt(data, 19, 19)                         //OK
        dataModel.time = byteToInt(data, 26, 27)                             //OK
        
        //Compruebo si alguno es /= 0
        checkDataBytes(data)
        
    }
    
    func byteToInt(_ data: Data, _ i: Int, _ j: Int) -> Int {
        return data[i...j].reversed().reduce(0) { (result, byte) in
            (result << 8) | Int(byte)
        }
    }
    
    func checkDataBytes(_ data: Data) {
        // Aseguramos que el tamaño del Data sea exactamente 30 bytes
        guard data.count == 30 else {
            print("Error: El Data proporcionado no tiene exactamente 30 bytes.")
            return
        }
        
        // Lista de índices a verificar
        let indicesToCheck = [4, 5, 8, 9, 12, 16, 17, 18, 20, 21, 22, 23, 24, 25, 28, 29]
        
        for index in indicesToCheck {
            let byte = data[index] // Accedemos al byte correspondiente
            if byte != 0 {
                print("El byte en la posición \(index) es distinto de 0: \(byte)")
            }
        }
    }
}
