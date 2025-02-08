//
//  APIError.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/01/30.
//
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unknown

    var title: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid Response"
        case .invalidData: return "Invalid Data"
        case .unknown: return "Unknown Error"
        }
    }

    var description: String {
        switch self {
        case .invalidURL: return "The URL provided is invalid."
        case .invalidResponse: return "Failed to get a valid response from the server."
        case .invalidData: return "The data received from the server is invalid."
        case .unknown: return "An unknown error occurred."
        }
    }
}
