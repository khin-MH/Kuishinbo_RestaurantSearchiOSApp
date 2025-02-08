//
//  SearchAreaModel.swift
//  KUISHINBO
////
//  Created by KHIN MYOHTUN on 2025/02/02.
//

import Foundation
import MapKit

@MainActor
class SearchAreaModel: ObservableObject {
    @Published var areaShops: [Shop] = [] // Stores restaurants for a selected area
    @Published var isLoading = false

    private enum Constants {
        static let baseURL = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/"
        static let apiKey = "9205537628e05e1f" 
    }

    func fetchRestaurants(for area: String) async {
        isLoading = true
        defer { isLoading = false }

        guard let encodedArea = area.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Error encoding area name")
            return
        }

        let urlString = "\(Constants.baseURL)?key=\(Constants.apiKey)&keyword=\(encodedArea)&count=20&format=json"

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
            self.areaShops = gourmet.results.shop ?? []
        } catch {
            print("Error fetching area shops: \(error.localizedDescription)")
        }
    }
}
