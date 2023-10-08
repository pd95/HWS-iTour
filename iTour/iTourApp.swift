//
//  iTourApp.swift
//  iTour
//
//  Created by Philipp on 08.10.23.
//

import SwiftData
import SwiftUI

@main
struct iTourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Destination.self)
    }
}
