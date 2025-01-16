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
    /// Return imageData, if not present in cache it will download from the url and then store in cache. If this las attemp is unsuccesfull return a placeholder
    /// - Parameter url: url of the image
    /// - Returns: Image as Data
    ///
    func getImage(from url: URL) async throws -> Data
    
    /// Return image from the existing cache
    /// - Parameter url: url of the image
    /// - Returns: Image as Data
    func getImage(from url: String) -> Data?
    
    /// set object into cache
    /// - Parameters:
    ///   - data: image as Data
    ///   - url: key to be used, under this domain is url
    func storeImage(data: Data, forUrl url: String)
    
    /// Clear all cache content
    func clear()
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
    
    func getImage(from url: String) -> Data? {
        if let cachedData = cache.object(forKey: url as NSString) {
            return cachedData as Data
        }
        return nil
    }
    
    func clear() {
        cache.removeAllObjects()
    }
    
    func storeImage(data: Data, forUrl url: String) {
        cache.setObject(data as NSData, forKey: url as NSString)
    }
}


// won't ship with production code. We need to see cache content for test.
// at least during stage, dont blame me for this. Theres no other way to expose private vars.
#if DEBUG
extension ImageCache {
    func getCache() -> NSCache<NSString, NSData> {
        return self.cache
    }
}
#endif
