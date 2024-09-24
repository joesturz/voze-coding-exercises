//
//  ContentView.swift
//  MapExercise
//
//  Created by Joe Sturzenegger on 9/22/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var locations: [Int: Location] = [:]
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    //TODO: Add filter on location types
    @State private var locationTypes: Set<String> = []
    @State private var selectedTag: Int?
    @State private var selectedLocation: Location?
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selectedTag) {
            ForEach(Array(locations.keys), id: \.self) { id in
                if let location = locations[id] {
                    let name = location.getName()
                    Marker(name, systemImage: location.getSystemImage(), coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)).tag(location.id)
                }
            }
        }
        .onAppear {
            loadLocations()
        }
        .onChange(of: selectedTag) {
            if let selectedTag {
                if let newLocation = locations[selectedTag] {
                    selectedLocation = newLocation
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if selectedTag != nil {
                HStack {
                    Spacer()
                    InfoView(location: $selectedLocation)
                        .padding(.top)
                    Spacer()
                }
                .background(.thinMaterial)
            }
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
            let tempLocations = try decoder.decode([Location].self, from: data)
            for location in tempLocations {
                locations[location.id] = location
            }
            loadLocationTypes()
        } catch {
            print("Failed to load or decode data: \(error)")
        }
    }
    
    func loadLocationTypes() {
        locationTypes.insert("all")
        for id in locations.keys {
            if let location = locations[id] {
                locationTypes.insert(location.getLocationType())
            }
        }
    }
}
