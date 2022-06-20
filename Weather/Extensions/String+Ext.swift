//
//  String+Ext.swift
//  Weather
//
//  Created by user on 19.06.2022.
//

import Foundation

extension String {
    
    var urlEncode: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
}
