//
//  bikeDataModel.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 31/12/24.
//

import Foundation
import CoreBluetooth

class BikeDataModel {
    var speed: Double?
    var time: TimeInterval?
    var distance: Double?
    var calories: Double?
    var heartRate: Int?

    func updateData(from characteristic: CBCharacteristic) {
        guard let value = characteristic.value else { return }

        let data = [UInt8](value) // Convertir Data a un array de bytes

        // Asegúrate de que los datos tienen el tamaño esperado
        guard data.count >= 5 else {
            print("Datos insuficientes recibidos")
            return
        }

        // Decodificar los datos según el formato esperado
        speed = Double(data[0]) // Supongamos que el primer byte es la velocidad (en km/h)
        time = TimeInterval(data[1]) + TimeInterval(data[2] << 8) // Bytes 2-3 para tiempo (en segundos)
        distance = Double(data[3]) // Byte 4 para distancia (en metros)
        calories = Double(data[4]) // Byte 5 para calorías quemadas

        print("Datos actualizados:")
        print("Velocidad: \(speed ?? 0) km/h")
        print("Tiempo: \(time ?? 0) segundos")
        print("Distancia: \(distance ?? 0) metros")
        print("Calorías: \(calories ?? 0)")
    }

}

