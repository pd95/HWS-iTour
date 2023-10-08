//
//  ContentView.swift
//  iTour
//
//  Created by Philipp on 08.10.23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var path = [Destination]()
    @State private var sortOrder = [SortDescriptor(\Destination.name), SortDescriptor(\Destination.name)]
    @State private var searchText = ""

    var body: some View {
        NavigationStack(path: $path) {
            DestinationListingView(sort: sortOrder, search: searchText)
                .navigationDestination(for: Destination.self, destination: EditDestinationView.init)
                .navigationTitle("iTour")
                .searchable(text: $searchText)
                .toolbar {
                    Button("Add Destination", systemImage: "plus", action: addDestination)

                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder[0]) {
                            Text("Name")
                                .tag(SortDescriptor(\Destination.name))
                            Text("Priority")
                                .tag(SortDescriptor(\Destination.priority, order: .reverse))
                            Text("Date")
                                .tag(SortDescriptor(\Destination.date))
                        }
                        .pickerStyle(.inline)
                    }
                }
        }
    }

    func addDestination() {
        let destination = Destination()
        modelContext.insert(destination)
        path = [destination]
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Destination.self, configurations: config)
        let rome = Destination(name: "Rome", priority: 2)
        let florence = Destination(name: "Florence", priority: 3)
        let naples = Destination(name: "Naples", priority: 1)
        container.mainContext.insert(rome)
        container.mainContext.insert(florence)
        container.mainContext.insert(naples)
        return ContentView()
            .modelContainer(container)
    } catch {
        fatalError("Something went wrong!")
    }
}
