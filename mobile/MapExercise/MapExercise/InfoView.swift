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


