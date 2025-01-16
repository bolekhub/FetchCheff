//
//  RecipeView.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//
import SwiftUI
import UIKit

struct RecipeView: View {
    @Injected(\.imageCacheProvider) var imageCache: ImageCacheProtocol

    @State var model: Recipe
    @State var image: UIImage = UIImage.placeholder
    
    var body: some View {
        HStack {
            CachedAsyncImage(model: model)
            //Image(uiImage: image)
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(5)
                .shadow(radius: 5)
            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.headline)
                Text(model.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }.task {
            //guard let thumbURL = model.thumbnailURL, let url = URL(string: thumbURL) else { return }
            //image = await UIImage.fromURL(url: url)
        }
        .padding(15)
        .border(.bar, width: 2.5)
        .cornerRadius(5)
    }
}

#Preview {
    RecipeView(model:Recipe.xample)
}
