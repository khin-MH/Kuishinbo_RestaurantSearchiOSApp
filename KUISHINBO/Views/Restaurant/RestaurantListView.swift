//
//  RestaurantListView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/01/30.
//


import SwiftUI

struct RestaurantListView: View {
    let shops: [Shop]
    var onSelectShop: (Shop) -> Void // Callback for shop selection
    
    // Define the grid layout
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(shops) { shop in
                    NavigationLink(destination: RestaurantDetailView(shop: shop)) {
                        RestaurantCardView(shop: shop) // Reusable card view for each shop
                    }
                    .buttonStyle(PlainButtonStyle()) // Prevent default button styling
                    .contentShape(Rectangle()) // Ensures entire card is tappable
                }
            }
            .id(UUID())
            .padding(.horizontal)
            .padding(.top, 16)
            
        }
        .background(Color(.systemGroupedBackground)) // Consistent background color
    }
}

//#Preview {
//    RestaurantListView(shops: [
//        Shop(id: "1", name: "Sample Restaurant", address: "123 Tokyo Street", logoImage: nil, photo: nil, open: "10:00 AM - 9:00 PM", budget: Budget(name: "¥2000〜¥3000"))
//    ])
//}
