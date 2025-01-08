//
//  BluetoothPairingMenu.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 5/1/25.
//

import SwiftUI

struct BluetoothPairingMenu: View {
    @StateObject private var bleManager = BLEManager.shared
    @State private var isScanning = false
    var body: some View {
        VStack {
            NavigationView {
                        VStack {
                            Text("Bluetooth Devices")
                                .font(.title3)
                                .padding()

                            List(bleManager.discoveredFMSs, id: \.identifier) { device in
                                Button(action: {
                                    bleManager.connectToBike(device)
                                }) {
                                    HStack {
                                        Text(device.name ?? "Unknown")
                                        Spacer()
                                        if bleManager.isConnectedTo(device) {
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    isScanning = false
                                }
                            }) {
                                HStack {
                                    if isScanning {
                                        Spacer()
                                    }
                                    Text("Scan")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                    
                                    if isScanning {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                            .padding()
                                    }
                                }
                                .frame(width: 150, alignment: .bottom)
                                .background(Color.black)
                                .cornerRadius(30)
                            }
                            .disabled(isScanning)
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
