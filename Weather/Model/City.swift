//
//  City.swift
//  Weather
//
//  Created by user on 12.06.2022.
//

import Foundation

struct City: Codable {
    let name: String
    let country: AdminDivision1
}

struct AdminDivision1: Codable {
    let name: String
}
