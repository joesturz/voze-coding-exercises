//
//  InfoView.swift
//  MapExercise
//
//  Created by Joe Sturzenegger on 9/23/24.
//
import SwiftUI

struct InfoView: View {
    @Binding var location: Location?
    
    var body: some View {
        if let location = location {
            VStack {
                HStack {
                    Text(location.getName()).bold()
                }
                HStack {
                    Text(location.getDescription())
                }
                HStack {
                    Label(location.getLocationType().capitalized, systemImage: location.getSystemImage())
                }
                HStack {
                    Label("Estimated Revenue: \(location.getRevenue().formatted()) Million", systemImage: "dollarsign.circle")
                }
            }.background(.thinMaterial)
        }
    }
}

#Preview {
    struct Preview: View {
        @State var location: Location? = Location.init(id: 123, latitude: 123.0, longitude: 123.0, attributes: [
            Attribute(type: "name", value: ValueType.string("Apple")),
            Attribute(type: "description", value: ValueType.string("Apple Inc.")),
            Attribute(type: "location_type", value: ValueType.string("landmark")),
            Attribute(type: "estimated_revenue_millions", value: ValueType.double(100000.0)),
        ])
        var body: some View {
            InfoView(location: $location)
        }
    }
    return Preview()
    
}
