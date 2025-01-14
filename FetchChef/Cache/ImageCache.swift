//
//  ImageCache.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//
import Foundation


enum CacheEntry {
    case inProgress(Task<Recipe, Error>)
    case ready(Recipe)
}

final class CacheEntryObject {
    let entry: CacheEntry
    init(entry: CacheEntry) { self.entry = entry }
}

extension NSCache where KeyType == NSString, ObjectType == CacheEntryObject {
    subscript(_ url: URL) -> CacheEntry? {
        get {
            let key = url.absoluteString as NSString
            let value = object(forKey: key)
            return value?.entry
        }
        set {
            let key = url.absoluteString as NSString
            if let entry = newValue {
                let value = CacheEntryObject(entry: entry)
                setObject(value, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
}


protocol ImageCacheProtocol {
    func getImage(from url: URL) async throws -> Data
}

final class ImageCache: ImageCacheProtocol {
    static let shared = ImageCache()
    private lazy var cache: NSCache = {
        let _cache = NSCache<NSString, NSData>()
        _cache.totalCostLimit = 200
        _cache.countLimit = 1000
        return _cache
    }()

    func getImage(from url: URL) async throws -> Data {
        let cacheKey = NSString(string: url.absoluteString)
        
        if let cachedData = cache.object(forKey: cacheKey) {
            return cachedData as Data
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        cache.setObject(data as NSData, forKey: cacheKey)
        return data
    }
}
