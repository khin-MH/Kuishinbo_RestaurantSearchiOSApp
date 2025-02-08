//
//  ContentView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/01/29.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var selectedTab = 0 // Default tab is MapView
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Map View (Default)
            MapView()
                .tabItem {
                    Label("地図", systemImage: "map.fill")
                }
                .tag(0)
            
            // Search View
            SearchView()
                .tabItem {
                    Label("検索", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            // Save List View
            SavedListView()
                .tabItem {
                    Label("保存リスト", systemImage: "heart.fill")
                }
                .tag(2)
            
            // Booking View
            ReservationView()
                .tabItem {
                    Label("予約", systemImage: "calendar.badge.clock")
                }
                .tag(3)
            
            // Profile View
            MyPageView()
                .tabItem {
                    Label("マイページ", systemImage: "person.crop.circle")
                }
                .tag(4)
        }
        .accentColor(.orange) 
    }
}

// MARK: - Map View
struct MapView: View {
    @ObservedObject var manager = LocationManager()
    @StateObject var hotPepperModel = HotPepperModel()
    @State private var isExpanded = true // Set default to expanded
    @State private var selectedDistance: Double? = nil // Track selected distance
    @State private var selectedShop: Shop? // For annotation selection
    @State private var navigateToDetail = false // Trigger navigation to detail view
    @State private var showListView = false // Trigger navigation to list view

    var body: some View {
        NavigationView {
            ZStack {
                // Map View
                Map(
                    coordinateRegion: $manager.region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    annotationItems: hotPepperModel.filteredShops,
                    annotationContent: { shop in
                        MapAnnotation(coordinate: shop.coordinate) {
                            Button(action: {
                                selectedShop = shop
                                navigateToDetail = true
                            }) {
                                CustomAnnotationView(shop: shop)
                            }
                        }
                    }
                )
                .ignoresSafeArea(.all) // Keep tab bar visible
                .padding(.bottom,10)
                
                // Floating Cards and Search View
                VStack {
                    // SearchBarWithTagsView
                    SearchBarWithTagsView(
                        onDistanceSelected: { distance in
                            selectedDistance = distance
                            hotPepperModel.filterAndSortShops(by: distance)
                        }
                    )
                    
                    
                    Spacer()

                    // Floating Cards View
                    FloatingCardsView(
                        hotPepperModel: hotPepperModel,
                        isExpanded: $isExpanded,
                        selectedDistance: $selectedDistance
                    )
                    .padding(.bottom,-20) // Ensure it doesn't overlap with the tab bar
                }

                // Navigation to RestaurantDetailView
                NavigationLink(
                    destination: RestaurantDetailView(shop: selectedShop ?? Shop(id: "", name: "Default", address: nil, access: nil, area: nil, open: nil, close: nil, budget: nil, genre: nil, urls: nil, card: nil, e_money: nil, parking: nil, private_room: nil, non_smoking: nil, photo: nil, lat: nil, lng: nil)),
                    isActive: $navigateToDetail
                ) {
                    EmptyView()
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
