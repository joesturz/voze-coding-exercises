//
//  ContentView.swift
//  MapExercise
//
//  Created by Joe Sturzenegger on 9/22/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var locations: [Location] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    //TODO: Add filter on location types
    @State private var locationTypes: Set<String> = []
    
    var body: some View {
        let bounds = MapCameraBounds(centerCoordinateBounds: region)
        Map(bounds: bounds) {
            ForEach(locations) { location in
                let name = location.getName()
                Marker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                    Text(name)
                }.tag(location.id)
            }
        }.onAppear {
            loadLocations()
        }
    }

    func loadLocations() {
        guard let url = Bundle.main.url(forResource: "locations", withExtension: "json") else {
            print("😨 failed to locate file")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            locations = try decoder.decode([Location].self, from: data)
            loadLocationTypes()
        } catch {
            print("Failed to load or decode data: \(error)")
        }
    }
    
    func loadLocationTypes() {
        locationTypes.insert("all")
        for location in locations {
            locationTypes.insert(location.getLocationType())
        }
    }
}
