//
//  SwiftUIView.swift
//  MapExercise
//
//  Created by Joe Sturzenegger on 9/24/24.
//

import SwiftUI

struct PickerView: View {
    @Binding var selectedLocationType: String
    let locationTypes: Set<String>
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Spacer()
                    Label("Pick Something", systemImage: "list.bullet.rectangle")
                    Spacer()
                }
                HStack {
                    Picker("Location Type", selection: $selectedLocationType) {
                        ForEach(locationTypes.sorted(), id: \.self) { type in
                            Text(type.capitalized)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    struct Preview: View {
        @State var selectedLocationType = "all"
        let locationTypes: Set<String> = ["all", "restaurant", "park", "cafe"]
        var body: some View {
            PickerView(selectedLocationType: $selectedLocationType, locationTypes: locationTypes)
        }
    }
    return Preview()
    
}
