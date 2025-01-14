//
//  SampleData.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//

import UIKit
import SwiftData

fileprivate let imageData = UIImage(named: "chef_placeholder")?.jpegData(compressionQuality: 1.0)

extension Recipe {
    static var xample: Recipe {
        return Recipe(cuisine: "British",
                      name: "Apple & Blackberry Crumble",
                      thumbnail: imageData ?? Data(),
                      itemID: "599344f4-3c5c-4cca-b914-2210e3b3312f",
                      videoUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4",
                      image: imageData ?? Data()
        )}
}


extension FetchChefApp {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Recipe.self, configurations: config)
            let dummyData = Recipe(cuisine: "Malaysian",
                                   name: "Apam Balik",
                                   thumbnail: imageData ?? Data(),
                                   itemID: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                                   videoUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg",
                                   image: imageData ?? Data())
            container.mainContext.insert(dummyData)
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
