//
//  ThumbnailView.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/14/25.
//
import SwiftUI

struct ThumbnailView: View {
    let imageURL: URL
    
    var body: some View {
        AsyncImage(url: imageURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                Color.red
            } else {
                // Placeholder
                ProgressView()
            }
        }
        .frame(width: 100, height: 100)
    }
}
