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
    
    @EnvironmentObject var viewModel: MainViewModel
    
    @Query(sort: \Recipe.name) var items: [Recipe]
    
    @State private var selectedItem: Recipe?
    
    @State private var showingDetail = false
    
    init() {
        _items = Query(
            filter: #Predicate<Recipe> { recipe in
                true
            },
            sort: \Recipe.name
        )
    }

    var body: some View {
        NavigationSplitView {
            ScrollView {
                LazyVStack(alignment: .leading, pinnedViews: .sectionHeaders) {
                    ForEach(filteredItems) { item in
                        RecipeView(model: item)
                            .onLongPressGesture(perform: {
                                selectedItem = item
                                showingDetail = true
                            })
                    }
                }
                .sheet(isPresented: $showingDetail) {
                    if let selectedItem = selectedItem {
                        RecipeDetail(model: selectedItem)
                    } else {
                        Text(" ⚠️ ").font(.system(size: 40.0))
                        Text(" Error")
                            .font(.headline)
                        Text("Unable to get recipe full size image")
                            .font(.subheadline)
                    }
                }
                .navigationTitle("Recipes")
            }
            .refreshable(action: {
                viewModel.selectedCategory = "All"
                await retrieveData()
            })
        } detail: {
            Text("Select an item")
        }
        .task {
            await retrieveData()
        }
        
        Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
            let uniques:[Category] = Set<String>(items.map{$0.cuisine})
                .map{Category(name: $0)}
            
            Picker("Filter", selection: $viewModel.selectedCategory) {
                ForEach(uniques) { item in
                    Text(item.name)
                        .tag(item.name)
                }
            }
        }
    }
    

    private func retrieveData() async {
        do {
            let recipes = await viewModel.loadData()
            recipes.forEach { recipe in
                modelContext.insert(recipe)
            }
            try modelContext.save()
        } catch {
            debugPrint("Error saving model")
        }
    }

    /// Dynamically filters items based on the selected category
    private var filteredItems: [Recipe] {
        if viewModel.selectedCategory == "All" {
            return items
        } else {
            return items.filter { $0.cuisine == viewModel.selectedCategory }
        }
    }
}

#Preview {
    ContentView() //items: [Recipe.xample]
        .modelContainer(FetchChefApp.previewContainer)
}
