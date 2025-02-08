//
//  RestaurantDetailView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/01/30.
//

import SwiftUI
import MapKit

struct RestaurantDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let shop: Shop
    @State private var showNavigationMap = false // Trigger navigation map
    @State private var travelTime: String = "Calculating..."
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading, spacing: 16) {
                // Restaurant photo
                AsyncImage(url: URL(string: shop.photo?.mobile?.l ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } placeholder: {
                    Color.gray
                        .frame(height: 200)
                        .cornerRadius(10)
                        .overlay(
                            Text("No Image Available")
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                }
                
                
                // Restaurant name
                Text(shop.name ?? "No Name")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Divider()
                
                // Address
                DetailRow(icon: "mappin.and.ellipse", label: shop.address ?? "Not available")
                
                // Access
                DetailRow(icon: "tram.fill", label: shop.access ?? "Not available")
                
                // Open hours
                DetailRow(icon: "clock.fill", label: "営業時間: \(shop.open ?? "Not available")")
                
                // Close days
                DetailRow(icon: "calendar.badge.minus", label: "定休日: \(shop.close ?? "Not available")")
                
                // Budget
                DetailRow(icon: "dollarsign.circle.fill", label: "予算: \(shop.budget?.name ?? "Not available")")
                
                // Website URL
                if let url = shop.urls?.pc, let websiteURL = URL(string: url) {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.orange)
                        Link("店舗ページを見る", destination: websiteURL)
                    }
                    .font(.body)
                }
                
                // Credit card
                DetailRow(icon: "creditcard.fill", label: "クレジットカード: \(shop.card ?? "Not available")")
                
                // Electronic money
                DetailRow(icon: "iphone", label: "電子マネー: \(shop.e_money ?? "Not available")")
                
                // Parking availability
                DetailRow(icon: "car.fill", label: "駐車場: \(shop.parking ?? "Not available")")
                
                // Private room
                DetailRow(icon: "door.left.hand.closed", label: "個室: \(shop.private_room ?? "Not available")")
                
                // Non-smoking information
                DetailRow(icon: "nosign", label: "禁煙情報: \(shop.non_smoking ?? "Not available")")
                
                // Button to open navigation in app's map
                if let lat = shop.lat, let lng = shop.lng {
                    Button(action: {
                        showNavigationMap = true // Show navigation map
                    }) {
                        HStack {
                            Image(systemName: "map")
                                .foregroundColor(.white)
                            Text("ナビを開始")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.orange)
                        .cornerRadius(10)
                        .padding(.vertical)
                    }
                    .sheet(isPresented: $showNavigationMap) {
                        NavigationMapWithTimeView(destination: CLLocationCoordinate2D(latitude: lat, longitude: lng))
                    }

                }
            }
            .padding()
        }
        .navigationTitle("店舗詳細")
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

struct DetailRow: View {
    let icon: String
    let label: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 24)
            Text(label)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}
