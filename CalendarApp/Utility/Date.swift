//
//  Date.swift
//  CalendarApp
//
//  Created by Binod Mandal on 09/10/21.
//

import Foundation

extension Date {
    
    func year() -> Int? {
        
        //let calendar = Calendar.de
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        
        let year = dateFormatter.string(from: self)
        return Int(year)
    }
}

