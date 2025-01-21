//
//  CachedAsyncImage.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/14/25.
//
import SwiftUI
import UIKit

struct CachedAsyncImage: View {
    @State var model: Recipe
    @Injected(\.imageCacheProvider) var imageCache: ImageCacheProtocol
    
    var thumbURL: URL? {
        guard let urlString = model.thumbnailURL else { return nil }
        return URL(string: urlString)
    }
    
    var body: some View {
        if let cachedImage = imageCache.getImage(from: thumbURL?.absoluteString ?? "" ) {
            Image(uiImage: UIImage(data: cachedImage)!)
                .resizable()
                .scaledToFit()
        } else {
            AsyncImage(url: thumbURL) { phase in
                EmptyView()
                    .handleAsyncImagePhase(phase, url: thumbURL!)
            }
        }
    }
}


extension View {
    func handleAsyncImagePhase(_ phase: AsyncImagePhase, url: URL) -> some View {
        self.modifier(AsyncImagePhaseModifier(phase: phase, url: url))
    }
}
