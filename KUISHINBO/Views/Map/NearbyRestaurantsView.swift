//
//  NearbyRestaurantsView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/02/01.
//

import SwiftUI

struct NearbyRestaurantsView: View {
    @ObservedObject var hotPepperModel: HotPepperModel
    @State private var selectedShop: Shop? = nil // Track the selected shop
    @State private var showDetail = false // Track whether the detail view is shown
    @Binding var isExpanded: Bool // Binding to toggle back to the main map view
    @Binding var selectedDistance: Double? // Track the selected distance
    @Environment(\.presentationMode) var presentationMode // For dismissing the view

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("近くのお店一覧")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 20)
                    .padding(.bottom, 8)

                Spacer()

                // "Back to Map" button
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Properly dismiss the view
                }) {
                    HStack {
                        Image(systemName: "map")
                            .resizable()
                            .frame(width: 20,height: 20)
                        Text("地図")
                            .font(.headline)
                    }
                    .padding(.top,10)
                    .foregroundColor(.orange)
                }
            }
            .padding(.horizontal)

            Spacer()

            if hotPepperModel.isLoading {
                VStack {
                    Spacer()
                    Text("Loading nearby shops...")
                        .foregroundColor(.gray)
                        .font(.headline)
                    Spacer()
                }
            } else if hotPepperModel.filteredShops.isEmpty {
                VStack {
                    Spacer()
                    Text("No nearby shops found.")
                        .foregroundColor(.gray)
                        .font(.headline)
                    Spacer()
                }
            } else {
                RestaurantListView(
                    shops: hotPepperModel.filteredShops,
                    onSelectShop: { shop in
                        selectedShop = shop
                        showDetail = true
                    }
                )
            }
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showDetail) {
            if let shop = selectedShop {
                RestaurantDetailView(shop: shop)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
        .onAppear {
            Task {
                if let distance = selectedDistance {
                    print("Filtering by distance: \(distance) meters")
                    hotPepperModel.filterAndSortShops(by: distance)
                } else {
                    print("Fetching nearby shops")
                    await hotPepperModel.fetchGourmet(for: .nearby)
                }
            }
        }
        .onChange(of: selectedDistance) { newValue in
            Task {
                if let distance = newValue {
                    print("Filtering by new distance: \(distance) meters")
                    hotPepperModel.filterAndSortShops(by: distance)
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide default back button

    }
}
