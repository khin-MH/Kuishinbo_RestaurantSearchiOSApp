//
//  RestaurantCardView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/02/01.
//

import SwiftUI

struct RestaurantCardView: View {
    let shop: Shop

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image Section
            if let imageUrl = shop.photo?.mobile?.l, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 120) // Larger width and height for images
                        .clipped()
                        .cornerRadius(12) // Keep rounded corners
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 200, height: 120) // Match placeholder size to image
                        .cornerRadius(12)
                }
            }

            // Restaurant Info
            VStack(alignment: .leading, spacing: 4) {
                // Name
                Text(shop.name ?? "No Name")
                    .font(.headline) // Slightly larger font size
                    .lineLimit(1)
                    .foregroundColor(.primary)

                // Address
                if let address = shop.address {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.orange)
                        Text(address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }

                // Genre
                if let genre = shop.genre?.name {
                    HStack {
                        Image(systemName: "fork.knife.circle.fill")
                            .foregroundColor(.orange)
                        Text(genre)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                // Budget
                if let budget = shop.budget?.name {
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.orange)
                        Text(budget)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding([.leading, .trailing], 8) // Keep padding for alignment
        }
        .frame(width: 180) // Larger card width
        .background(Color(.systemBackground))
        .cornerRadius(12) // Maintain the same card design
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

//#Preview {
//    RestaurantCardView()
//}
