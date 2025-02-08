//
//  NavigationMapView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/02/06.
//
import SwiftUI
import MapKit

struct NavigationMapView: UIViewRepresentable {
    let destination: CLLocationCoordinate2D
    @Binding var travelTime: String // Binding to show travel time

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: NavigationMapView

        init(parent: NavigationMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true

        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking // Walking mode

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            
            // Add the route overlay to the map
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            // Update the travel time in minutes
            let minutes = Int(route.expectedTravelTime / 60)
            DispatchQueue.main.async {
                context.coordinator.parent.travelTime = "\(minutes) min"
            }
        }

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // No updates needed for now
    }
}

// Wrapper to combine SwiftUI Text with UIViewRepresentable Map
struct NavigationMapWithTimeView: View {
    let destination: CLLocationCoordinate2D
    @State private var travelTime: String = "Calculating..." // State to hold travel time
    @Environment(\.presentationMode) var presentationMode // Environment for dismissing the view

    var body: some View {
        ZStack {
            NavigationMapView(destination: destination, travelTime: $travelTime)

            VStack {
                // Display travel time as an overlay
                Text("所要時間: \(travelTime)")
                    .font(.headline)
                    .padding(8)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 16)
                
                Spacer()
                
                // Back button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Dismiss the map view
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(.headline)
                            Text("Back")
                                .font(.headline).bold()
                        }
                        .padding()
                        .background(Color.orange)
                        .frame(width: 100,height: 50)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                    .padding(.leading, 16)
                    
                    Spacer() // Push button to the left
                }
                .padding(.bottom, 16)
            }
        }
    }
}

