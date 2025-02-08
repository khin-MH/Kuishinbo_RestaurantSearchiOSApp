//
//  SearchGenreModel.swift
//  KUISHINBO
//
//
//  Created by KHIN MYOHTUN on 2025/02/02.
//
import Foundation
import MapKit

@MainActor
class SearchGenreModel: ObservableObject {
    @Published var genreShops: [Shop] = [] // Fetched restaurants
    private let locationManager = LocationManager() // Use for getting user's current location

    private enum Constants {
        static let baseURL = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key="
        static let apiKey = "9205537628e05e1f" 
    }

    /// Fetch restaurants for the selected genre near the user's location
    func fetchNearbyRestaurants(for genre: String) async {
        let latitude = locationManager.region.center.latitude
        let longitude = locationManager.region.center.longitude

        guard latitude != 0.0, longitude != 0.0 else {
            print("Invalid location coordinates.")
            return
        }

        let urlString = "\(Constants.baseURL)\(Constants.apiKey)&lat=\(latitude)&lng=\(longitude)&keyword=\(genre)&range=5&count=50&format=json"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let gourmet = try JSONDecoder().decode(Gourmet.self, from: data)
            self.genreShops = gourmet.results.shop ?? []
        } catch {
            print("Error fetching restaurants: \(error.localizedDescription)")
        }
    }
}
