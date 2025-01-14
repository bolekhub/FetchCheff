//
//  Untitled.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//

import Foundation

struct RecipeAdapter {
    @Injected(\.imageCacheProvider) static var imageCache: ImageCacheProtocol

    static func adapt(dto: RecipeDTO) async throws -> Recipe {
        let thumbnailURL = URL(string: dto.photoURLSmall)
        let imageURL = URL(string: dto.photoURLLarge)
        
        // Fetch images asynchronously in parallel
        async let thumbnailData: Data? = {
            if let url = thumbnailURL {
                return try? await imageCache.getImage(from: url)
            }
            return nil
        }()
        
        async let imageData: Data? = {
            if let url = imageURL {
                return try? await imageCache.getImage(from: url)
            }
            return nil
        }()
        
        // Wait for all tasks to complete
        let thumbnail = await thumbnailData
        let image = await imageData ?? Data() 
        
        // Return the adapted `Recipe`
        return Recipe(
            cuisine: dto.cuisine,
            name: dto.name,
            thumbnail: thumbnail,
            itemID: dto.uuid,
            videoUrl: dto.youtubeURL,
            image: image
        )
    }
}

