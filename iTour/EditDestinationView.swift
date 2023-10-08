//
//  EditDestinationView.swift
//  iTour
//
//  Created by Philipp on 08.10.23.
//

import SwiftData
import SwiftUI

struct EditDestinationView: View {
    @Environment(\.modelContext) private var modelContext

    @Bindable var destination: Destination
    @State private var newSightName = ""

    var body: some View {
        Form {
            TextField("Name", text: $destination.name)

            TextField("Details", text: $destination.details, axis: .vertical)

            DatePicker("Date", selection: $destination.date)

            Section("Priority") {
                Picker("Priority", selection: $destination.priority) {
                    Text("Meh").tag(1)
                    Text("Maybe").tag(2)
                    Text("Must").tag(3)
                }
                .pickerStyle(.segmented)
            }

            Section("Sights") {
                ForEach(destination.sights) { sight in
                    Text(sight.name)
                }
                .onDelete { indexSet in
                    destination.sights.remove(atOffsets: indexSet)
                }

                HStack {
                    TextField("Add a new sight in \(destination.name)", text: $newSightName)
                        .onSubmit(addSight)

                    Button("Add", action: addSight)
                }
            }
        }
        .navigationTitle("Edit destination")
        .navigationBarTitleDisplayMode(.inline)
    }

    func addSight() {
        guard newSightName.isEmpty == false else { return }
        withAnimation {
            let sight = Sight(name: newSightName)
            destination.sights.append(sight)
            newSightName = ""
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Destination.self, configurations: config)
        let example = Destination(name: "Example Destination", details: "Example details go here and will automatically expand vertically as they are edited.")
        return EditDestinationView(destination: example)
            .modelContainer(container)
    } catch {
        fatalError("Something went wrong!")
    }
}
