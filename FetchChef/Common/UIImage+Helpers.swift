//
//  UIImage+Helpers.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/14/25.
//
import UIKit

extension UIImage {
    static func fromURL(url: URL) async -> UIImage {
        @Injected(\.imageCacheProvider) var imageCache: ImageCacheProtocol
        do {
            let imageData = try await imageCache.getImage(from: url)
            guard let imageFromData = UIImage(data: imageData) else {
                return .placeholder }
            return imageFromData
        } catch {
            return .placeholder
        }
    }
    
    static var placeholder: UIImage {
        UIImage(systemName: "circle.slash") ?? UIImage()
    }
}
