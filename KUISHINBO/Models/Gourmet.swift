//
//  Gourmet.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/01/30.
//

import Foundation
import MapKit 

struct Gourmet: Codable {
    let results: Results
}

struct Results: Codable {
    let shop: [Shop]?
}


struct Shop: Codable, Identifiable, Hashable {
    let id: String
    let name: String?
    let address: String?
    let access: String?
    let area: String?
    let open: String?
    let close: String?
    let budget: Budget?
    let genre: Budget?
    let urls: URLs?
    let card: String?
    let e_money: String?
    let parking: String?
    let private_room: String?
    let non_smoking: String?
    let photo: Photo?
    let lat: Double? // Latitude
    let lng: Double? // Longitude
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Unique ID for hashing
    }

    static func == (lhs: Shop, rhs: Shop) -> Bool {
        return lhs.id == rhs.id // Equality based on unique ID
    }

}

// MARK: - Extension for Identifiable and Coordinate
extension Shop {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat ?? 0.0, longitude: lng ?? 0.0)
    }
}

struct URLs: Codable {
    let pc: String? // Store page URL (for PC)
}

struct Photo: Codable {
    let mobile: MobilePhoto? // Mobile Photo URLs
}

struct MobilePhoto: Codable {
    let l: String? // Large Photo URL
    let s: String? // Small Photo URL
}

struct Budget: Codable {
    let name: String? // Budget Name (e.g., "¥2000〜¥3000")
}

struct Genre: Codable {
    let name: String? // Genre Name (e.g., "Japanese Cuisine")
}
