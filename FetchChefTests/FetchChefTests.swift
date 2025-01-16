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
    let recipesContentOKResource: URL? = {
        let mainBundle = Bundle.main
        return mainBundle.url(forResource: "recipes", withExtension: "json")
    }()
    
    let recipesEmptyResource: URL? = {
        let mainBundle = Bundle.main
        return mainBundle.url(forResource: "recipes-empty", withExtension: "json")
    }()
    
    let recipesMalformedContentResource: URL? = {
        let mainBundle = Bundle.main
        return mainBundle.url(forResource: "recipes-malformed", withExtension: "json")
    }()

    @Test("API Calls") func test_recipes_api() async throws {
        try await testAPIResults()
    }
    
    @Test("API Calls - Correct parsing") func test_DomainObjects_fullfilled() async throws {
        try await testAPIparser_DTO_to_Model()
    }
    
    @Test("API Calls - Malformed Json") func test_malformed_json_once() async throws {
        try await test_malformed_json_parse_and_fail_decoding()
    }
    
    @Test("API Calls - No Recipes_empty") func test_empty_resource_parsing() async throws {
        try await test_empty_recipes()
    }
    
    @Test("Image Cache - correct caching") func test_image_caching() async throws {
        try await test_imageCaching()
    }
}


private extension FetchChefTests {
    func testAPIResults() async throws {
        guard let recipesContentOKResource else { return }
        let api = RecipeAPI(url: recipesContentOKResource, checkStatusCode: false)
        let response: [RecipeDTO]? = try await api.fetchRecipe()
        #expect(response?.count == 63)
    }
    
    func testAPIparser_DTO_to_Model() async throws {
        guard let recipesContentOKResource else { return }
        let api = RecipeAPI(url: recipesContentOKResource, checkStatusCode: false)
        let response: [RecipeDTO]? = try await api.fetchRecipe()
        #expect(response != nil)
        #expect(response?.count == 63)
        guard let recipes = response else { return }
        
        var recipesFull = [Recipe]()
        for recipe in recipes {
            let ad = Recipe(dto: recipe)
            recipesFull.append(ad)
        }
        #expect(recipesFull.count == 63)
    }
    
    func test_malformed_json_parse_and_fail_decoding()  async throws {
        guard let recipesMalformedContentResource else { return }
        let api = RecipeAPI(url: recipesMalformedContentResource, checkStatusCode: false)
        do {
            let response: [RecipeDTO]? = try await api.fetchRecipe()
            #expect(response == nil)
        } catch {
            if case .decodingFailed(_ ) = error {
                #expect(error != nil)
            }
        }
    }
    
    func test_empty_recipes()  async throws {
        guard let recipesEmptyResource else { return }
        let api = RecipeAPI(url: recipesEmptyResource, checkStatusCode: false)
        do {
            let response: [RecipeDTO]? = try await api.fetchRecipe()
            #expect(response != nil)
            #expect(response?.count == 0)
        } catch { }
    }
    
    func test_imageCaching() async throws {
        let testURL = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"

        @Injected(\.imageCacheProvider) var imageCache: ImageCacheProtocol
        imageCache.clear()
        
        if let cache = (imageCache as? ImageCache) {
            let cachedImage = cache.getCache().object(forKey: testURL as NSString)
            #expect(cachedImage == nil)
            #expect(cachedImage?.count ?? 0 == 0)
        }
        
        guard let thumbURL = URL(string: testURL) else { return }
        let image = try await imageCache.getImage(from: thumbURL)
        #expect(image != nil)
        
        if let cache = (imageCache as? ImageCache) {
            let cachedImage = cache.getCache().object(forKey: testURL as NSString)
            #expect(cachedImage != nil)
            #expect(cachedImage?.count ?? 0 == 11500)
        }
    }
}
