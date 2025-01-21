//
//  AsyncImagePhaseModifier.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/21/25.
//

import SwiftUI

struct AsyncImagePhaseModifier: ViewModifier {
    let phase: AsyncImagePhase
    let url: URL
    
    @Injected(\.imageCacheProvider) var imageCache: ImageCacheProtocol
    
    func body(content: Content) -> some View {
        Group {
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .onAppear(perform: {
                        if let uiImage = ImageRenderer(content: image).uiImage {
                            if let imageData = uiImage.pngData() {
                                imageCache.storeImage(data: imageData, forUrl: url.absoluteString)
                            }
                        }
                    })
            case .failure(_):
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.red)
            @unknown default:
                Image(systemName: "questionmark")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }
        }
    }
}
