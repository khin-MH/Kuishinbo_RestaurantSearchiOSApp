//
//  LocationUtils.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/02/02.
//

import CoreLocation

/// Calculates the distance between two locations in meters.
/// - Parameters:
///   - userLocation: The user's current location.
///   - shopLocation: The shop's location.
/// - Returns: The distance in meters.
/// 
func calculateDistance(from userLocation: CLLocation, to shopLocation: CLLocation) -> Double {
    return userLocation.distance(from: shopLocation)
}
