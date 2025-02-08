//
//  SearchDetailView.swift
//  KUISHINBO
//

import SwiftUI

struct SearchDetailView: View {
    let option: String // Selected area
    let restaurants: [Shop] // List of restaurants from SearchAreaModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var savedRestaurantsModel: SavedRestaurantsModel // Access shared data
    @State private var isFavorite: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if restaurants.isEmpty {
                // Display a message when no restaurants are found
                VStack {
                    Image(systemName: "fork.knife.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    Text("レストランが見つかりませんでした")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("他のエリアやジャンルを試してみてください。")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 50)
            } else {
                VStack(spacing: 16) {
                    ForEach(restaurants, id: \.id) { restaurant in
                        NavigationLink(destination: RestaurantDetailView(shop: restaurant)) {
                            RestaurantSearchCardView(restaurant: restaurant)
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove default NavigationLink styling
                    }
                }
                .padding()
            }
        }
        .navigationTitle(option.isEmpty ? "エリアを読み込んでいます..." : "\(option)のレストラン")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
            }
        }
    }
}

// MARK: - Restaurant Card UI
struct RestaurantSearchCardView: View {
    let restaurant: Shop
    @EnvironmentObject var savedRestaurantsModel: SavedRestaurantsModel // Access shared model
    @State private var isFavorite: Bool = false // For heart icon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Restaurant Info
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(restaurant.name ?? "Unknown")
                        .font(.title3)
                        .foregroundColor(.primary).bold()
                    
                    Spacer()
                    
                    // Favorite Button (Heart Icon)
                    Button(action: {
                        isFavorite.toggle()
                        if isFavorite {
                            savedRestaurantsModel.addRestaurant(restaurant)
                        } else {
                            savedRestaurantsModel.removeRestaurant(restaurant)
                        }
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .gray)
                    }
                }
                Divider()
                
                InfoRow(icon: "location.fill", title: "アクセス", value: restaurant.access ?? "No Access Info")
                InfoRow(icon: "clock.fill", title: "営業時間", value: restaurant.open ?? "No Hours Info")
                InfoRow(icon: "creditcard.fill", title: "バジェット", value: restaurant.budget?.name ?? "No Budget Info")
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        .onAppear {
            // Check if the restaurant is in the saved list and update `isFavorite`
            isFavorite = savedRestaurantsModel.savedRestaurants.contains(where: { $0.id == restaurant.id })
        }
    }
}

// MARK: - Reusable Row UI
struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
    }
}
