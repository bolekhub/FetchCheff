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
    var videoUrl: String?
    
    init(cuisine: String, name: String, thumbnail: String, itemID: String, videoUrl: String?, imageURL: String) {
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

extension Recipe {
    static var xample: Recipe {
        return Recipe(cuisine: "British",
                      name: "Apple & Blackberry Crumble",
                      thumbnail: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                      itemID: "599344f4-3c5c-4cca-b914-2210e3b3312f",
                      videoUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4",
                      imageURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg")
    }
}
