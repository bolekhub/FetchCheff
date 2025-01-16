//
//  MainViewModel.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/14/25.
//

import SwiftUI
import SwiftData

 final class MainViewModel: ObservableObject {
     private let api = RecipeAPI(checkStatusCode: true)
     
     @Published var selectedCategory: String = "All"

     @Published var showingDetail: Bool = false

     @Published private(set) var filteredRecipes: [Recipe] = []

     
     func loadData() async -> [Recipe] {
         do {
             let items: [RecipeDTO]? = try await api.fetchRecipe()
             
             var recipes = [Recipe]()
             items?.forEach({ recipe in
                 let itm = Recipe(dto: recipe)
                 recipes.append(itm)
             })
             return recipes
         } catch {
             print("Error \(error.localizedDescription)")
         }
         return []
     }
     
     func saveItems(items: [Recipe], context: ModelContext) throws {
         items.forEach { recipe in
             context.insert(recipe)
         }
         try context.save()
     }
}
