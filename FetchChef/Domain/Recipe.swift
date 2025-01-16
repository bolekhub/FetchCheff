//
//  Item.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//

import Foundation
import SwiftData

// This model suport the transformation of the urls

@Model
final class Recipe {
    @Attribute(.unique) var itemID: String
    var cuisine: String
    var name: String
    var thumbnailURL: String?
    var imageURL: String?
    var videoUrl: String?
    
    init(cuisine: String, name: String, thumbnailURI: String?, itemID: String, videoUrl: String?, imageURI: String) {
        self.cuisine = cuisine
        self.name = name
        self.thumbnailURL = thumbnailURI
        self.imageURL = imageURI
        self.itemID = itemID
        self.videoUrl = videoUrl
    }

    convenience init(dto: RecipeDTO) {
        self.init(cuisine: dto.cuisine,
                  name: dto.name,
                  thumbnailURI: dto.photoURLSmall,
                  itemID: dto.uuid,
                  videoUrl: dto.youtubeURL,
                  imageURI: dto.photoURLLarge)
    }
}


