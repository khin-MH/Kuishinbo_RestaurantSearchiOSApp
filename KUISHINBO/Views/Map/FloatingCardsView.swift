//
//  FloatingCardsView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/02/05.
//

import SwiftUI

struct FloatingCardsView: View {
    @ObservedObject var hotPepperModel: HotPepperModel
    @Binding var isExpanded: Bool
    @Binding var selectedDistance: Double? // Track the selected distance
    @State private var selectedShop: Shop? = nil // Track the selected shop for navigation
    @EnvironmentObject var savedRestaurantsModel: SavedRestaurantsModel // Access shared data

    var body: some View {
        VStack(spacing: 0) {
            if hotPepperModel.isLoading {
                VStack {
                    Spacer()
                    Text("近くのお店を検索中...")
                        .foregroundColor(.orange)
                        .font(.headline)
                    Spacer()
                }
            } else if hotPepperModel.filteredShops.isEmpty {
                VStack {
                    Spacer()
                    Text("近くのお店は見つかりません")
                        .foregroundColor(.orange)
                        .font(.headline)
                    Spacer()
                }
            } else {
                // Floating Cards for Shops
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(hotPepperModel.filteredShops, id: \.id) { shop in
                            FloatingShopCard(shop: shop)
                                .environmentObject(savedRestaurantsModel) // Pass down the model
                                .frame(width: 360) // Adjusted width
                                .onTapGesture {
                                    selectedShop = shop
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
                .background(Color.clear) // Transparent background
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.bottom, 16)
            }

            // Navigation to RestaurantDetailView
            if let selectedShop = selectedShop {
                NavigationLink(
                    destination: RestaurantDetailView(shop: selectedShop),
                    isActive: Binding(
                        get: { self.selectedShop != nil },
                        set: { if !$0 { self.selectedShop = nil } }
                    )
                ) {
                    EmptyView()
                }
            }
        }
        .background(Color.clear.edgesIgnoringSafeArea(.all)) // Transparent background for entire view
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
    }
}


struct FloatingShopCard: View {
    let shop: Shop
    @EnvironmentObject var savedRestaurantsModel: SavedRestaurantsModel // Access shared data
    @State private var isFavorite: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Shop Image
            if let imageURL = URL(string: shop.photo?.mobile?.l ?? "") {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(10)
                        .shadow(radius: 2)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                }
            }

            // Shop Details
            VStack(alignment: .leading, spacing: 6) {
                Text(shop.name ?? "No Name")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(shop.genre?.name ?? "Unknown Genre")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Text(shop.budget?.name ?? "No Budget Info")
                    .font(.system(size: 14))
                    .foregroundColor(.orange)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            VStack(spacing: 30) {
                // Favorite Button (Heart Icon)
                // Favorite Button (Heart Icon)
                Button(action: {
                    isFavorite.toggle()
                    if isFavorite {
                        savedRestaurantsModel.addRestaurant(shop)
                    } else {
                        savedRestaurantsModel.removeRestaurant(shop)
                    }
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                }

                // Online Reservation Button (if applicable)
                if let _ = shop.urls?.pc {
                    Text("ネット予約可")
                        .font(.system(size: 12))
                        .foregroundColor(.yellow)
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.yellow, lineWidth: 1)
                                .background(Color.yellow.opacity(0.1).cornerRadius(4))
                        )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground).opacity(1))
                .shadow(radius: 4)
            )
        .onAppear {
            // Check if the restaurant is in the saved list and update `isFavorite`
            isFavorite = $savedRestaurantsModel.savedRestaurants.contains(where: { $0.id == shop.id })
        }
    }
}
