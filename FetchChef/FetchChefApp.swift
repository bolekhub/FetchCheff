//
//  FetchChefApp.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//

import SwiftUI
import SwiftData

@main
struct FetchChefApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Recipe.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    <#code#>
                }
        }
        .modelContainer(sharedModelContainer)
        
    }
}

