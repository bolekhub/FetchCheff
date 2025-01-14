//
//  DI.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//

public protocol InjectionKey {
    
    /// The associated type representing the type of the dependency injection key's value.
    associatedtype Value
    
    /// The default value for the dependency injection key.
    static var currentValue: Self.Value { get set }
}

// DI keys to register
private struct ImageCacheKey: InjectionKey {
    static var currentValue: ImageCacheProtocol = ImageCache()
}

extension InjectedValues {
    var imageCacheProvider: ImageCacheProtocol {
        get { Self[ImageCacheKey.self] }
        set { Self[ImageCacheKey.self] = newValue }
    }
}
