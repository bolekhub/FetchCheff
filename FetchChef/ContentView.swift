//
//  ContentView.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Recipe.name) private var items: [Recipe]
    
    
    var body: some View {
        NavigationSplitView {
            List(items) { item in
                NavigationLink(destination: RecipeView(model: item)) {
                    RecipeView(model: item)
                }
            }
            .navigationTitle("Recipes")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }.onAppear {
            
        }
    }

    private func addItem() {
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(FetchChefApp.previewContainer)
}
