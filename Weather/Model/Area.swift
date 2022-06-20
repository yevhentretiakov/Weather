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
    var name: String {
        adminArea ?? country ?? ""
    }
}
