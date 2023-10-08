//
//  DestinationListingView.swift
//  iTour
//
//  Created by Philipp on 08.10.23.
//

import SwiftData
import SwiftUI

struct DestinationListingView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: [SortDescriptor(\Destination.priority, order: .reverse), SortDescriptor(\Destination.name)])
    private var destinations: [Destination]

    init(sort: SortDescriptor<Destination>, search: String = "") {
        _destinations = Query(filter: #Predicate {
            search.isEmpty || $0.name.localizedStandardContains(search)
        }, sort: [sort])
    }

    var body: some View {
        List {
            ForEach(destinations) { destination in
                NavigationLink(value: destination) {
                    VStack(alignment: .leading) {
                        Text(destination.name)
                            .font(.headline)

                        Text(destination.date.formatted(date: .long, time: .shortened))
                    }
                }
            }
            .onDelete(perform: deleteDestinations)
        }
    }

    func deleteDestinations(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = destinations[index]
            modelContext.delete(destination)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Destination.self, configurations: config)
        let rome = Destination(name: "Rome")
        let florence = Destination(name: "Florence")
        let naples = Destination(name: "Naples")
        container.mainContext.insert(rome)
        container.mainContext.insert(florence)
        container.mainContext.insert(naples)
        return DestinationListingView(sort: SortDescriptor(\Destination.name))
            .modelContainer(container)
    } catch {
        fatalError("Something went wrong!")
    }
}
