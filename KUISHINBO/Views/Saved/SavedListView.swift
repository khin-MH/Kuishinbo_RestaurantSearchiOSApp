//
//  SavedListView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/02/01.
//

import SwiftUI

struct SavedListView: View {
    @EnvironmentObject var savedRestaurantsModel: SavedRestaurantsModel // Access saved restaurants
    @Environment(\.presentationMode) var presentationMode // For dismissing the sheet

    @State private var showDeleteConfirmation = false
    @State private var selectedRestaurant: Shop? // Track which restaurant is selected for deletion

    var body: some View {
        NavigationView {
            VStack {
                if savedRestaurantsModel.savedRestaurants.isEmpty {
                    // No saved restaurants message
                    VStack {
                        Image(systemName: "heart.slash.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                        
                        Text("保存したレストランはありません")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 50)
                } else {
                    // Display saved restaurants in a simple list with small images
                    List {
                        ForEach(savedRestaurantsModel.savedRestaurants, id: \.id) { shop in
                            HStack {
                                // Display small image (if available)
                                AsyncImage(url: URL(string: shop.photo?.mobile?.l ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } placeholder: {
                                    Image(systemName: "photo") // Default icon
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                }

                                // Restaurant Name & Address
                                VStack(alignment: .leading) {
                                    Text(shop.name ?? "No Name")
                                        .font(.headline)
                                    Text(shop.address ?? "住所不明")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Image(systemName: "chevron.right") // Indicate navigation
                                    .foregroundColor(.gray)
                            }
                            .contentShape(Rectangle()) // Make the whole row tappable
                            .onTapGesture {
                                selectedRestaurant = shop // Set for navigation
                            }
                            .onLongPressGesture {
                                selectedRestaurant = shop
                                showDeleteConfirmation = true // Show delete confirmation
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("保存リスト")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .sheet(item: $selectedRestaurant) { shop in
                // Navigate to detailed restaurant view
                RestaurantDetailView(shop: shop)
            }
            .confirmationDialog("このレストランを削除しますか？", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                Button("削除", role: .destructive) {
                    if let restaurant = selectedRestaurant {
                        savedRestaurantsModel.removeRestaurant(restaurant)
                    }
                }
                Button("キャンセル", role: .cancel) { }
            }
        }
    }
}
