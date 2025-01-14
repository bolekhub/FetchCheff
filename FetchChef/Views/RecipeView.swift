//
//  RecipeView.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//
import SwiftUI

struct RecipeView: View {
    @State var model: Recipe
    
    var body: some View {
        HStack {
            Image(uiImage: getImage() )
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
        }
        .padding(15)
        .border(.bar, width: 2.5)
        .cornerRadius(5)
    }
    
    func getImage() -> UIImage {
        return  UIImage(data: model.thumbnail ?? Data()) ?? UIImage(named: "chef_placeholder") ?? UIImage()
    }
}

#Preview {
    RecipeView(model:Recipe.xample)
}
