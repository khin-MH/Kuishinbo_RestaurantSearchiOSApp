//
//  SearchBarView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/02/08.
//

import SwiftUI

struct SearchView: View {
    @StateObject var hotPepperModel = HotPepperModel() // Instance of HotPepperModel
    @State private var selectedRestaurant: Shop? // Track selected restaurant for navigation

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    TextField("お店を検索", text: $hotPepperModel.searchText, onCommit: {
                        performSearch()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .font(.system(size: 18))

                    // Clear Button ('X')
                    if !hotPepperModel.searchText.isEmpty {
                        Button(action: {
                            clearSearch()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 5)
                        }
                    }

                    // Search Button
                    Button(action: {
                        performSearch()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                            .background(Color(.systemGray6))
                            .foregroundColor(.orange)
                            .clipShape(Circle())
                    }
                }
                .padding()

                // Loading Indicator
                if hotPepperModel.isLoading {
                    ProgressView("検索中...")
                        .padding()
                }

                // Results Area
                if hotPepperModel.filteredShops.isEmpty && !hotPepperModel.isLoading {
                    Text("該当するお店が見つかりませんでした。")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 10) {
                            ForEach(hotPepperModel.filteredShops, id: \.id) { shop in
                                Button(action: {
                                    selectedRestaurant = shop // Set the selected restaurant
                                }) {
                                    ShowShopCard(shop: shop)
                                }
                                .buttonStyle(PlainButtonStyle()) // Avoids the default button styling
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                }

                Spacer()
            }
            .background(Color(.systemBackground))
            .onAppear {
                Task {
                    // Fetch default results when the view appears
                    if hotPepperModel.filteredShops.isEmpty && hotPepperModel.searchText.isEmpty {
                        await hotPepperModel.fetchGourmet(for: .recommend)
                    }
                }
            }
            // NavigationLink to RestaurantDetailView
            .navigationBarTitleDisplayMode(.inline)
            .background(
                NavigationLink(
                    destination: selectedRestaurant.map { RestaurantDetailView(shop: $0) },
                    isActive: Binding(
                        get: { selectedRestaurant != nil },
                        set: { if !$0 { selectedRestaurant = nil } }
                    )
                ) {
                    EmptyView()
                }
            )
        }
    }

    // Perform search when the user enters text
    private func performSearch() {
        guard !hotPepperModel.searchText.isEmpty else { return }
        hotPepperModel.isLoading = true

        Task {
            await hotPepperModel.fetchRestaurants(for: hotPepperModel.searchText)
        }
    }

    // Clear search text and reset to default shops
    private func clearSearch() {
        hotPepperModel.searchText = ""
        hotPepperModel.filteredShops = [] // Clear current results
        Task {
            await hotPepperModel.fetchGourmet(for: .recommend) // Fetch default shops
        }
    }
}


struct DynamicColorImage: View {
    let systemName: String
    var body: some View {
        Image(systemName: systemName)
            .foregroundColor(.white)
    }
}


struct ShowShopCard: View {
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
                    .font(.system(size: 15, weight: .bold))
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
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground).opacity(1))
                .shadow(radius: 4)
            )
        .onAppear {
            // Check if the restaurant is in the saved list and update `isFavorite`
            isFavorite = $savedRestaurantsModel.savedRestaurants.contains(where: { $0.id == shop.id })
        }
    }
}
