//
//  MainView.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 31/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bleManager = BLEManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("Elíptica")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            HStack {
                StatView(label: "Velocidad", value: "\(bleManager.dataModel.speed ?? 0)", unit: "km/h")
                StatView(label: "Tiempo", value: "\(Int(bleManager.dataModel.time ?? 0))", unit: "segundos")
            }

            HStack {
                StatView(label: "Distancia", value: "\(bleManager.dataModel.distance ?? 0)", unit: "metros")
                StatView(label: "Calorías", value: "\(bleManager.dataModel.calories ?? 0)", unit: "kcal")
            }

            Spacer()

            Button(action: {
                bleManager.startScanning()
            }) {
                Text("Conectar Bicicleta")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
