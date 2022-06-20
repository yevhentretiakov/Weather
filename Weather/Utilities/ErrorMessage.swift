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
    
    case cantGetGeo = "We cant get city by geo so try manual selection!"
    case cantGetArea = "We cant get administrative area by this point. Please try again."
}
