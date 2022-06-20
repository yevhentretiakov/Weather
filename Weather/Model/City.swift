//
//  City.swift
//  Weather
//
//  Created by user on 12.06.2022.
//

import Foundation

struct City: Codable {
    let name: String
    let country: Country
    var localizedName: String?
    let coordinates: Coordinate
}

struct Country: Codable {
    let name: String
    let localizedName: String?
}
