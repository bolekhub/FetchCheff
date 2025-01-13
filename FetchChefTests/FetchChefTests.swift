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

    @Test("API Calls") func example() async throws {
        try await testAPIResults()
    }

    func testAPIResults() async throws {
        let mainBundle = Bundle.main
        guard let jsonUrl = mainBundle.url(forResource: "recipes", withExtension: "json") else { return }
        let api = RecipeAPI(url: jsonUrl, checkStatusCode: false)
        let response: [RecipeDTO]? = try await api.fetchRecipe()
        #expect(response?.count == 63)
    }
}
