//
//  ErrorMessage.swift
//  Weather
//
//  Created by user on 09.06.2022.
//

import Foundation

enum ErrorMessage: String, Error {
    case unableToComplete = "unableToComplete"
    case invalidResponse = "invalidResponse"
    case invalidData = "invalidData"
    case nothingFind = "nothingFind"
    case emptySearch = "emptySearch"
    case cantGetGeo = "cantGetGeo"
    case cantGetArea = "cantGetArea"
}
