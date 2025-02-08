//
//  SearchBarWithTagsView.swift
//  KUISHINBO
//
//
//  Created by KHIN MYOHTUN on 2025/02/03.
//

import SwiftUI

struct SearchBarWithTagsView: View {
    @StateObject var hotPepperModel = HotPepperModel()
    @State private var selectedDistance: String? = nil // Track selected distance
    let distances: [String] = ["300m", "500m", "1km", "2km", "3km"] // Distance ranges
    let onDistanceSelected: (Double) -> Void // Callback for distance selection
    @Environment(\.colorScheme) var colorScheme // Access the current color scheme
    @State private var showListView = false
    
    var body: some View {
        VStack(spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    generateDistanceButtons()
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 10)
            .background(
                            (colorScheme == .light ? Color.white : Color.black)
                                .opacity(0.9)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                        )
            
            Button(action: {
                showListView = true
            }) {
                Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width:18, height: 18)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding(.leading,300)
            
        }
        .padding(.horizontal)
        .background(
            NavigationLink(
                destination: NearbyRestaurantsView(
                    hotPepperModel: hotPepperModel,
                    isExpanded: .constant(true),
                    selectedDistance: .constant(nil)
                ),
                isActive: $showListView
            ) {
                EmptyView()
            }
        )
    }

    /// Extracted method to generate distance buttons
    private func generateDistanceButtons() -> some View {
        ForEach(distances, id: \.self) { distance in
            Button(action: {
                selectedDistance = distance
                let distanceValue = convertDistanceToMeters(distance)
                onDistanceSelected(distanceValue)
            }) {
                HStack {
                    Image(systemName: "location")
                        .font(.system(size: 14, weight: .bold))
                    Text(distance)
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundColor(
                    selectedDistance == distance
                        ? (colorScheme == .dark ? .black : .white) // Selected: Black (light theme) or White (dark theme)
                        : (colorScheme == .dark ? .white : .black) // Unselected: White (dark theme) or Black (light theme)
                )
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(
                    selectedDistance == distance
                        ? (colorScheme == .dark ? Color.orange : Color.orange) // Selected: Orange for both themes
                        : (colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray5)) // Unselected: Gray for both themes
                )
                .cornerRadius(20)
                .shadow(
                    color: selectedDistance == distance
                        ? Color.orange.opacity(0.4) // Shadow for selected
                        : Color.clear,              // No shadow for unselected
                    radius: 5, x: 0, y: 3
                )
            }
        }
    }

    /// Convert distance strings like "500m", "1km" to meters as `Double`
    private func convertDistanceToMeters(_ distance: String) -> Double {
        switch distance {
        case "300m": return 300.0
        case "500m": return 500.0
        case "1km": return 1000.0
        case "2km": return 2000.0
        case "3km": return 3000.0
        default: return 0.0
        }
    }
}
