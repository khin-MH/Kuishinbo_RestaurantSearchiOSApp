//
//  SavedRestaurantsModel.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/02/03.
//

import Foundation

class SavedRestaurantsModel: ObservableObject {
    @Published var savedRestaurants: [Shop] = [] {
        didSet {
            saveToUserDefaults()
        }
    }

    private let savedKey = "savedRestaurants"

    init() {
        loadFromUserDefaults()
    }

    // Save the list to UserDefaults
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(savedRestaurants) {
            UserDefaults.standard.set(encoded, forKey: savedKey)
        }
    }

    // Load the list from UserDefaults
    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: savedKey),
           let decoded = try? JSONDecoder().decode([Shop].self, from: data) {
            savedRestaurants = decoded
        }
    }

    func addRestaurant(_ restaurant: Shop) {
        if !savedRestaurants.contains(where: { $0.id == restaurant.id }) {
            savedRestaurants.append(restaurant)
        }
    }

    func removeRestaurant(_ restaurant: Shop) {
        savedRestaurants.removeAll(where: { $0.id == restaurant.id })
    }
}
