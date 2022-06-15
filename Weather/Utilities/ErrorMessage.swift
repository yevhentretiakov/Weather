//
//  ErrorMessage.swift
//  Weather
//
//  Created by user on 09.06.2022.
//

import Foundation

enum ErrorMessage: String, Error {
    case unableToComplete = "Unable to complete your request. Please try again."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case nothingFind = "We couldn't find anything for that search."
    case emptySearch = "Enter something in the search field and try again."
}
