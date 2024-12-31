//
//  bluetooth.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 31/12/24.
//

import CoreBluetooth

//Gestion la conexión BLE
class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var dataModel = BikeDataModel()

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // Inicia el escaneo de dispositivos
            centralManager.scanForPeripherals(withServices: nil)
        } else {
            print("Bluetooth no está disponible.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Dispositivo encontrado: \(peripheral.name ?? "Sin nombre")")
        centralManager.stopScan()
        connectedPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Conectado a: \(peripheral.name ?? "Sin nombre")")
        connectedPeripheral?.delegate = self
        connectedPeripheral?.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                print("Servicio encontrado: \(service.uuid)")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("Característica encontrada: \(characteristic.uuid)")
                // Suscribirse a las características según sea necesario
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let value = characteristic.value {
            // Procesar el valor recibido y actualizar el modelo de datos
            dataModel.updateData(from: characteristic)
        }
    }
}
