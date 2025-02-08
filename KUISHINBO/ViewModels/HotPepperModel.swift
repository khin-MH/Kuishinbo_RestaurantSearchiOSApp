//
//  HotPepperModel.swift
//  KUISHINBO
//

import Foundation
import MapKit

@MainActor
class HotPepperModel: ObservableObject {
    @Published var shops = [Shop]() // List of restaurants
    @Published var searchText: String = ""
    @Published var filteredShops: [Shop] = [] // Filtered shops based on distance or other criteria
    @Published var areaShops: [Shop] = [] // Stores restaurants for a selected area
    @Published var genreShops: [Shop] = [] // Fetched restaurants
    @Published var isLoading = false // Loading state
    let locationManager = LocationManager()
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) // Default location
    
    private enum Constants {
        static let baseURL = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key="
        static let apiKey = "9205537628e05e1f" 
    }
    
    func fetchRestaurants(for area: String) async {
        isLoading = true
        defer { isLoading = false }

        guard let encodedArea = area.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Error encoding area name")
            return
        }

        let urlString = "\(Constants.baseURL)\(Constants.apiKey)&keyword=\(encodedArea)&count=50&format=json"

        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
            }

            let gourmet = try JSONDecoder().decode(Gourmet.self, from: data)
            self.shops = gourmet.results.shop ?? []
            self.filteredShops = self.shops // Keep filteredShops updated
        } catch {
            print("Error fetching area shops: \(error.localizedDescription)")
        }
    }

    
    func fetchGourmet(for type: FetchType, area: String? = nil) async {
        isLoading = true
        defer { isLoading = false }
        
        let latitude = locationManager.region.center.latitude
        let longitude = locationManager.region.center.longitude
        
        var urlString: String
        switch type {
        case .nearby:
            // Fetch nearby shops
            urlString = "\(Constants.baseURL)\(Constants.apiKey)&lat=\(latitude)&lng=\(longitude)&range=5&count=50&format=json"
        case .recommend:
            // Fetch recommended shops
            urlString = "\(Constants.baseURL)\(Constants.apiKey)&lat=\(latitude)&lng=\(longitude)&range=5&keyword=人気&count=50&format=json"
        }
        
        // If area is specified, override the URL with area-based search
        if let area = area, !area.isEmpty {
            urlString = "\(Constants.baseURL)\(Constants.apiKey)&keyword=\(area)&count=50&format=json"
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Log the raw JSON response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }
            
            // Decode the JSON response into the Gourmet model
            let gourmet = try JSONDecoder().decode(Gourmet.self, from: data)
            self.shops = gourmet.results.shop ?? []
            self.filteredShops = self.shops // Initialize filteredShops to show all shops
            
            print("Fetched \(self.shops.count) shops.")
        } catch {
            print("Error fetching shops: \(error.localizedDescription)")
        }
    }

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
    
    func filterAndSortShops(by radius: Double) {
        let userLocation = locationManager.region.center
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)

        // Debug: Log total shops before filtering
        print("Total shops before filtering: \(shops.count)")

        let filtered = shops.filter { shop in
            guard let shopLat = shop.lat, let shopLng = shop.lng else {
                print("Missing location data for shop: \(shop.name ?? "Unknown")")
                return false
            }

            let shopLocation = CLLocation(latitude: shopLat, longitude: shopLng)
            let distance = userCLLocation.distance(from: shopLocation)

            return distance <= radius
        }

        // Debug: Log filtered shops
        print("Filtered shops: \(filtered.count) within radius \(radius)m")

        self.filteredShops = filtered.sorted { shop1, shop2 in
            let loc1 = CLLocation(latitude: shop1.lat ?? 0.0, longitude: shop1.lng ?? 0.0)
            let loc2 = CLLocation(latitude: shop2.lat ?? 0.0, longitude: shop2.lng ?? 0.0)
            return userCLLocation.distance(from: loc1) < userCLLocation.distance(from: loc2)
        }

        // Notify observers of the update
        objectWillChange.send()

        // Debug: Log sorted shops
        print("Sorted Shops:")
        for shop in self.filteredShops {
            let shopLocation = CLLocation(latitude: shop.lat ?? 0.0, longitude: shop.lng ?? 0.0)
            let distance = userCLLocation.distance(from: shopLocation)
            print("\(shop.name ?? "Unknown") - \(distance)m")
        }
    }

        
        enum FetchType {
            case nearby
            case recommend
        }
    }
    
