//
//  Item.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//

import Foundation
import SwiftData

@Model
final class Recipe {
    var cuisine: String
    var name: String
    var thumbnailURL: String
    var imageURL: String
    var itemID: String
    var videoUrl: String
    
    init(cuisine: String, name: String, thumbnail: String, itemID: String, videoUrl: String, imageURL: String) {
        self.cuisine = cuisine
        self.name = name
        self.thumbnailURL = thumbnail
        self.imageURL = imageURL
        self.itemID = itemID
        self.videoUrl = videoUrl
    }
    
    convenience init(recipe: RecipeDTO) {
        self.init(cuisine: recipe.cuisine,
                  name: recipe.name,
                  thumbnail: recipe.photoURLSmall,
                  itemID: recipe.uuid,
                  videoUrl: recipe.youtubeURL,
                  imageURL: recipe.photoURLLarge)
    }
}
