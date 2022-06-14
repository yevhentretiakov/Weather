//
//  PlaceSearchManager.swift
//  Weather
//
//  Created by user on 12.06.2022.
//

import Foundation

class PlaceSearchManager {
    
    private init(){}
    
    static let shared = PlaceSearchManager()
    
    let baseURL = "https://spott.p.rapidapi.com/places/"
    
    let headers = [
        "X-RapidAPI-Key": "9db7477293msh3ec32684a8daddfp162246jsn917496510bd0",
        "X-RapidAPI-Host": "spott.p.rapidapi.com"
    ]
    
    func fetchCities(prefix: String) async throws -> [City] {
        
        let lang = Locale.current.languageCode ?? "en"
        
        guard let encodedPrefix = prefix.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            throw ErrorMessage.error
        }
        
        let endPoint = baseURL + "autocomplete?limit=100&skip=0&language=\(lang)&type=CITY&q=\(encodedPrefix)"
        
        guard let url = URL(string: endPoint) else {
            throw ErrorMessage.error
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ErrorMessage.error
        }
        
        do {
            let decoder = JSONDecoder()
            let cities = try decoder.decode([City].self, from: data)
            return cities
        } catch {
            throw ErrorMessage.error
        }
    }
}
