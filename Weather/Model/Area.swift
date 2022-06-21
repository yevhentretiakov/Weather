//
//  Area.swift
//  Weather
//
//  Created by user on 20.06.2022.
//

import Foundation

struct Area {
    let adminArea: String?
    let country: String?
    let coordinate: Coordinate?
}

extension Area {
    var availableName: String? {
        adminArea ?? country
    }
    var availableNamesList: [String] {
        var names = [String]()
        
        if let adminArea = adminArea {
            names.append(adminArea)
        }
        if let country = country {
            names.append(country)
        }
        
        return names
    }
}
