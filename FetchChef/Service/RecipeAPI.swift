//
//  RecipeAPI.swift
//  FetchChef
//
//  Created by Boris Chirino Fernández on 1/13/25.
//
import Foundation

enum NetworkError: Error {
    case badUrl(innerError: Error?)
    case requestFailed(innerError: URLError)
    case decodingFailed(innerError: DecodingError)
    case encodingFailed(innerError: EncodingError)
    case otherError(innerError: Error)
    case badRequest
}

final class RecipeAPI {
    private static var endpointURL: URL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    private var apiURL: URL
    private var checkStatusCode: Bool = true
    
    init(url: URL = RecipeAPI.endpointURL, checkStatusCode: Bool) {
        self.apiURL = url
        self.checkStatusCode = checkStatusCode
    }

    func fetchRecipe<T: Codable>() async throws(NetworkError) -> [T]? {
        return try await getData()
    }
    
    private func getData<T: Codable>() async throws(NetworkError) -> [T]? {
        do {
            let (data, response) = try await URLSession.shared.data(from: apiURL)
            
            // TODO: this check is to avoid problems during testing due to load json file not httprequest
            if checkStatusCode {
                guard  let response = response as? HTTPURLResponse, 200...300 ~= response.statusCode else { throw NetworkError.badRequest }
            }

            let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return decodedResponse.recipes as? [T]
            
        } catch let error as DecodingError {
            throw .decodingFailed(innerError: error)
        } catch let error as EncodingError {
            throw .encodingFailed(innerError: error)
        } catch let error as URLError {
            throw .requestFailed(innerError: error)
        } catch {
            throw .otherError(innerError: error)
        }
    }
}

extension Error {
    var genericError: Error {
        return NSError(domain: "APP", code: 100, userInfo: [NSLocalizedDescriptionKey: "bad url"])
    }
}

fileprivate struct RecipeResponse: Codable {
     var recipes: [RecipeDTO]
}

