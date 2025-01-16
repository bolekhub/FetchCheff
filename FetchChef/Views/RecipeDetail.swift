//
//  RecipeDetail.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//

import SwiftUI

struct RecipeDetail: View {
    @State var model: Recipe
    @State var image: UIImage = UIImage.placeholder

    var body: some View {
        VStack {
            Image(uiImage: image)
                .frame(maxWidth: .infinity, alignment: .leading)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(5)
                .shadow(radius: 5)
            Spacer()
            Link(" 📺 Recipe Video ", destination: URL(string: model.videoUrl!)!)
        }
        .task {
            guard let thumbURL = model.imageURL, let url = URL(string: thumbURL) else { return }
            image = await UIImage.fromURL(url: url)
        }
    }
}

#Preview {
    RecipeDetail(model: Recipe.xample)
}
