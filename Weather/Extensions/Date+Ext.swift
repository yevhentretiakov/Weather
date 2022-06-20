//
//  Date+Ext.swift
//  Weather
//
//  Created by user on 09.06.2022.
//

import Foundation

extension Date {
    
    func extract(_ format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func date(byAdding component: Calendar.Component, value: Int) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: component, value: value, to: self)
    }
    
    func isSameDayAs(_ date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
}

