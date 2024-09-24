//
//  ContentView.swift
//  MapExercise
//
//  Created by Joe Sturzenegger on 9/22/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var locationsDict: [Int: Location] = [:]
    @State private var filteredLocations: [Location] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var locationTypes: Set<String> = []
    @State private var selectedTag: Int?
    @State private var selectedLocation: Location?
    @State private var selectedLocationType: String = "all"
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selectedTag) {
            ForEach(filteredLocations) { location in
                let name = location.getName()
                Marker(name, systemImage: location.getSystemImage(), coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)).tag(location.id)
            }
        }
        .onAppear {
            loadLocations()
        }
        .onChange(of: selectedTag) {
            if let selectedTag {
                if let newLocation = locationsDict[selectedTag] {
                    selectedLocation = newLocation
                }
            }
        }
        .onChange(of: selectedLocationType) {
            filteredLocations = Array(locationsDict.values).filter({
                if selectedLocationType == "all" {
                    return true
                } else {
                    return $0.getLocationType() == selectedLocationType
                }
            } )
        }
        .safeAreaInset(edge: .top, content: {
            HStack {
                PickerView(selectedLocationType: $selectedLocationType, locationTypes: locationTypes)
            }
            .background(.thinMaterial)
        })
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
    
    /**
     This loads all the locations into the locaitons Dict and
     filteredLocations array
     */
    private func loadLocations() {
        guard let url = Bundle.main.url(forResource: "locations", withExtension: "json") else {
            print("😨 failed to locate file")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            filteredLocations = try decoder.decode([Location].self, from: data)
            for location in filteredLocations {
                locationsDict[location.id] = location
            }
            loadLocationTypes()
        } catch {
            print("Failed to load or decode data: \(error)")
        }
    }
    
    /**
     This gets all the location types, the assignment said they were static
     but i thought this was just as easy.
     */
    private func loadLocationTypes() {
        locationTypes.insert("all")
        for id in locationsDict.keys {
            if let location = locationsDict[id] {
                locationTypes.insert(location.getLocationType())
            }
        }
    }
}
