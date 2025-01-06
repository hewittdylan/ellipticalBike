//
//  ContentView.swift
//  ellipticalBike
//
//  Created by Dylan Hewitt on 31/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: TabItem = .home
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $activeTab) {
                HomeView()
                    .tag(TabItem.home)
                TrainView()
                    .tag(TabItem.train)
                Text("Records")
                    .tag(TabItem.records)
                Text("Profile")
                    .tag(TabItem.profile)
            }
            InteractiveTabBar(activeTab: $activeTab)
        }
    }
}

struct InteractiveTabBar: View {
    @Binding var activeTab: TabItem
    @Namespace private var animation
    @State private var tabButtonLocations: [CGRect] = Array(repeating: .zero, count: TabItem.allCases.count)
    @State private var activeDraggingTab: TabItem?
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabButton(tab)
            }
        }
        .frame(height: 70)
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
        .background {
            Rectangle()
                .fill(.background.shadow(.drop(color: .primary.opacity(0.2), radius: 5)))
                .ignoresSafeArea()
                .padding(.top, 20)
        }
        .coordinateSpace(.named("TABBAR"))
    }
    
    @ViewBuilder
    func TabButton(_ tab: TabItem) -> some View {
        let isActive = (activeDraggingTab ?? activeTab) == tab
        
        VStack(spacing: 6) {
            Image(systemName: tab.symbolImage)
                .frame(width: isActive ? 50 : 25, height: isActive ? 50 : 25)
                .background {
                    if isActive {
                        Circle()
                            .fill(.white.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
                .frame(width: 25, height: 25, alignment: .bottom)
                .contentShape(.rect)
                //.padding(isActive ? 0 : 20)
                .foregroundStyle(isActive ? .black : .white)
            
            Text(tab.rawValue)
                .font(.caption2)
                .foregroundStyle(isActive ? .white : .gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .onGeometryChange(for: CGRect.self, of: {
            $0.frame(in: .named("TABBAR"))
        }, action: { newValue in
            tabButtonLocations[tab.index] = newValue
        })
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.snappy) {
                activeTab = tab
            }
        }
        .gesture(
            DragGesture(coordinateSpace: .named("TABBAR"))
                .onChanged { value in
                    let location = value.location
                    if let index = tabButtonLocations.firstIndex(where: { $0.contains(location) }) {
                        withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                            activeDraggingTab = TabItem.allCases[index]
                        }
                    }
                }.onEnded { _ in
                    if let activeDraggingTab {
                        activeTab = activeDraggingTab
                    }
                    activeDraggingTab = nil
                },
            isEnabled: activeTab == tab
        )
    }
}

#Preview {
    ContentView()
}

enum TabItem: String, CaseIterable {
    case home = "Home"
    case train = "Train"
    case records = "Records"
    case profile = "Profile"
    
    var symbolImage: String {
        switch self {
            case .home: return "house.fill"
            case .train: return "figure.elliptical"
            case .records: return "list.clipboard.fill"
            case .profile: return "person.fill"
        }
    }
    
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}
