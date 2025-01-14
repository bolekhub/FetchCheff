//
//  Item.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//

import Foundation
import SwiftData

// This model suport the transformation of the urls ( thumbnail and fullsize image ) into their own data by calling create method will adapt Data to domain objects with data transformed. This may cause an overhead dealing with network calls if transformation are made in a batch and not used carefully. This is common an issue in projects where model and services separation of concern are not clear. 
@Model
final class Recipe {
    @Attribute(.unique) var itemID: String
    var cuisine: String
    var name: String
    var thumbnail: Data?
    var image: Data
    var videoUrl: String?
    
    init(cuisine: String, name: String, thumbnail: Data?, itemID: String, videoUrl: String?, image: Data) {
        self.cuisine = cuisine
        self.name = name
        self.thumbnail = thumbnail
        self.image = image
        self.itemID = itemID
        self.videoUrl = videoUrl
    }
    
    static func create(from dto: RecipeDTO) async throws -> Recipe {
        let thumbnailURL =  URL(string: dto.photoURLSmall)
        let imageURL = URL(string: dto.photoURLLarge)
        return try await RecipeAdapter.adapt(dto: dto)
    }
    
    /*
    convenience init(recipe: RecipeDTO) {
        self.init(cuisine: recipe.cuisine,
                  name: recipe.name,
                  thumbnail: recipe.photoURLSmall,
                  itemID: recipe.uuid,
                  videoUrl: recipe.youtubeURL,
                  image: recipe.photoURLLarge)
    }
     */
}


