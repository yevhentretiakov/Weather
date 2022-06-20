//
//  NetworkManager.swift
//  Weather
//
//  Created by user on 18.06.2022.
//

import Foundation

enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

protocol HTTPRequest {
    
    var url: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String: String]? { get }
    var headers: [String: String]? { get }
}

enum ApiEndpoint {
    
    case getWeather(areaName: String)
    case getCities(prefx: String)
}

extension ApiEndpoint: HTTPRequest {
    
    var url: String {
        switch self {
        case .getWeather(let areaName):
            let baseURL: String = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services"
            let path: String = "/timeline"
            let encodedCityName = areaName.urlEncode
            return baseURL + path + "/" + encodedCityName
        case .getCities(_):
            let baseURL: String = "https://spott.p.rapidapi.com/places"
            let path: String = "/autocomplete"
            return baseURL + path
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getWeather(_):
            return .get
        case .getCities(_):
            return .get
        }
    }
    
    var queryItems: [String : String]? {
        switch self {
        case .getWeather(_):
            return [
                "unitGroup": "metric",
                "key": "PZXRTV7AHTLXDM6AJFFESATCB",
                "contentType": "json",
            ]
        case .getCities(let prefix):
            return [
                "limit": "100",
                "skip": "0",
                "type": "CITY",
                "q": prefix.urlEncode,
                "language": Locale.current.languageCode ?? "en"
            ]
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getWeather(_):
            return nil
        case .getCities(_):
            return [
                "X-RapidAPI-Key": "9db7477293msh3ec32684a8daddfp162246jsn917496510bd0",
                "X-RapidAPI-Host": "spott.p.rapidapi.com"
            ]
        }
    }
}

final class NetworkManager {
    
    private init() {}
    
    private let decoder = JSONDecoder()
    private let session = URLSession.shared
    
    static let shared = NetworkManager()
    
    func fetch<T: Decodable>(from endpoint: ApiEndpoint) async throws -> T {
        
        // Create URL
        guard var urlComponent = URLComponents(string: endpoint.url) else {
            throw ErrorMessage.unableToComplete
        }
        
        var queryItems: [URLQueryItem] = []
        
        endpoint.queryItems?.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            throw ErrorMessage.unableToComplete
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        // Get data
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ErrorMessage.invalidResponse
        }
        
        // Decode data
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ErrorMessage.invalidData
        }
    }
}
