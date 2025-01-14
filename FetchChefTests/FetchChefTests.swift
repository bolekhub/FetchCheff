//
//  FetchChefTests.swift
//  FetchChefTests
//
//  Created by Boris Chirino Fernández on 1/13/25.
//

import Testing
import Foundation
@testable import FetchChef

struct FetchChefTests {
    let jsonURL: URL? = {
        let mainBundle = Bundle.main
        return mainBundle.url(forResource: "recipes", withExtension: "json")
    }()

    @Test("API Calls") func example() async throws {
        try await testAPIResults()
    }
    
    @Test("Conversion") func testDomainObjects_fullfilled() async throws {
        try await testAPIparser()
    }

    func testAPIResults() async throws {
        guard let jsonURL else { return }
        let api = RecipeAPI(url: jsonURL, checkStatusCode: false)
        let response: [RecipeDTO]? = try await api.fetchRecipe()
        #expect(response?.count == 63)
    }
    
    func testAPIparser() async throws {
        guard let jsonURL else { return }
        let api = RecipeAPI(url: jsonURL, checkStatusCode: false)
        let response: [RecipeDTO]? = try await api.fetchRecipe()
        #expect(response != nil)
        #expect(response?.count == 63)
        guard let recipes = response else { return }
        
        var recipesFull = [Recipe]()
        for recipe in recipes {
            let ad = try await Recipe.create(from: recipe)
            recipesFull.append(ad)
        }
        #expect(recipesFull.count == 63)
        #expect(recipesFull.first?.image != nil)
    }
}
