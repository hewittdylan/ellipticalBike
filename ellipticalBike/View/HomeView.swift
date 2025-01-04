//
//  HomeView.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 31/12/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isMenuOpen = false
    @StateObject private var watchConnector = PhoneSessionManager.shared
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    watchConnector.startSession()
                }) {
                    Image(systemName: "applewatch")
                        .font(.title)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .scaleEffect(1)
                }
                .padding()
                Spacer()
                Button(action: {
                    isMenuOpen.toggle()
                }) {
                    Image(systemName: "link")
                        .font(.title)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .scaleEffect(0.8)
                }
                .padding()
            }
            Spacer()
        }
        .sheet(isPresented: $isMenuOpen) {
            BluetoothPairingMenuBike()
        }
    }
}

#Preview {
    HomeView()
}

struct BluetoothPairingMenuBike: View {
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
