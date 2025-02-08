//
//  RecommendRestaurantsView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/02/01.
//

import SwiftUI

struct RecommendRestaurantsView: View {
    @ObservedObject var hotPepperModel: HotPepperModel
    @State private var selectedShop: Shop? = nil // Track the selected shop
    @State private var showDetail = false // Track whether the detail view is shown
    @Binding var isExpanded: Bool
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("おすすめのお店一覧")
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
                    // Placeholder while loading
                    VStack {
                        Spacer()
                        Text("Loading recommended shops...")
                            .foregroundColor(.gray)
                            .font(.headline)
                        Spacer()
                    }
                } else if hotPepperModel.shops.isEmpty {
                    // Placeholder if no shops found
                    VStack {
                        Spacer()
                        Text("No recommended shops found.")
                            .foregroundColor(.gray)
                            .font(.headline)
                        Spacer()
                    }
                } else {
                    // Use RestaurantListView
                    RestaurantListView(
                        shops: hotPepperModel.shops,
                        onSelectShop: { shop in
                            selectedShop = shop // Set the selected shop
                            showDetail = true // Show detail view
                        }
                    )
                }
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $showDetail) {
                if let shop = selectedShop {
                    RestaurantDetailView(shop: shop)
                        .presentationDetents([.large]) // Full screen
                        .presentationDragIndicator(.visible) // Optional: Add a drag indicator
                }
            }
            .onAppear {
                Task {
                    await hotPepperModel.fetchGourmet(for: .recommend) // Fetch recommended shops
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide default back button
    }
}
