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
        AsyncImage(url: thumbURL) { phase in
            if let image = phase.image, let url = thumbURL {
                image.resizable()
            } else if phase.error != nil {
                Color.red
            } else {
                ProgressView()
            }
        }.cacheAsyncImage(for: thumbURL)
    }
        
        func getImageFromCache() -> UIImage? {
            guard let urlString = model.thumbnailURL,
                  let uiImage = imageCache.getImage(from: urlString),
                  let img = UIImage(data: uiImage) else {return nil}
            return img
        }
    
    private func storeImage(image: Image) {
        let img: UIImage? = ImageRenderer(content: image).uiImage
        if let imgData = img?.pngData(), let url = model.thumbnailURL {
            imageCache.storeImage(data: imgData, forUrl: url)
        }
    }
}


extension View {
    
    func cacheAsyncImage(for url: URL?) -> some View {
        @Injected(\.imageCacheProvider) var imageCache: ImageCacheProtocol
        func cacheAsyncImage(for url: URL, phase: AsyncImagePhase) -> some View {
            self.onAppear {
                if case .success(let image) = phase {
                    if let uiImage = ImageRenderer(content: image).uiImage {
                        if let imageData = uiImage.pngData() {
                            imageCache.storeImage(data: imageData, forUrl: url.absoluteString)
                        }
                    }
                }
                
            }
        }
        return self
    }
}


