//
//  MainViewModel.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/14/25.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    private let api = RecipeAPI(checkStatusCode: true)
    
    func loadData() async {
        do {
            let items: [RecipeDTO]? = try? await api.fetchRecipe()
            items?.forEach({ recipe in
                let itm = Recipe(cuisine: recipe.cuisine,
                                 name: recipe.name,
                                 thumbnail: <#T##Data?#>, itemID: <#T##String#>, videoUrl: <#T##String?#>, image: <#T##Data#>)
            })
            
        } catch {
            
        }
    }
}
