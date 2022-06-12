//
//  Int+Ext.swift
//  Weather
//
//  Created by user on 10.06.2022.
//

import Foundation

extension Int {
    var toDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}
