//
//  HotPepperAPIService.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/01/30.
//

import Foundation

final class HotPepperAPIService {
    static let shared = HotPepperAPIService()

    func request(with urlString: String) async throws -> Gourmet {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(Gourmet.self, from: data)
        } catch {
            throw APIError.invalidData
        }
    }
}
