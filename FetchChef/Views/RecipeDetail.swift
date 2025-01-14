//
//  RecipeDetail.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//

import SwiftUI

struct RecipeDetail: View {
    @State var model: Recipe

    var body: some View {
        VStack {
            Image(uiImage: getImage() )
                .frame(height: 300)
                .scaledToFit()
                .cornerRadius(5)
                .shadow(radius: 5)
            Link("youtibe", destination: URL(string: model.videoUrl!)!)
        }
    }
    
    func getImage() -> UIImage {
        return  UIImage(data: model.image) ?? UIImage(named: "chef_placeholder") ?? UIImage()
    }
}

#Preview {
    RecipeDetail(model: Recipe.xample)
}
