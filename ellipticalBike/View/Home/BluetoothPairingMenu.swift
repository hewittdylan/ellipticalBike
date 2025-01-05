//
//  BluetoothPairingMenu.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 5/1/25.
//

import SwiftUI

struct BluetoothPairingMenu: View {
    @StateObject private var bleManager = BikeDataModel.shared.bleManager!
    @State private var isScanning = false
    var body: some View {
        VStack {
            NavigationView {
                        VStack {
                            Text("Bluetooth Devices")
                                .font(.title3)
                                .padding()

                            List(bleManager.discoveredDevices, id: \.identifier) { device in
                                Button(action: {
                                    bleManager.connectToBike(device)
                                }) {
                                    HStack {
                                        Text(device.name ?? "Unknown")
                                        Spacer()
                                        if bleManager.connectedBike == device {
                                            Text("Conectado")
                                                .foregroundColor(.black)
                                                .font(.caption)
                                        }
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())

                            Button(action: {
                                isScanning = true
                                bleManager.startScanning()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    isScanning = false
                                }
                            }) {
                                Text(isScanning ? "Scanning" : "Scan")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .frame(width: 150, alignment: .bottom)
                                    .background(Color.black)
                                    .cornerRadius(30)
                            }
                            .padding()
                        }
                    }
        }
        .padding()
        .presentationDetents([.medium, .large])
    }
}


#Preview {
    BluetoothPairingMenu()
}
