//
//  Date.swift
//  intervieasy
//
//  Created by jevania on 06/05/24.
//

import Foundation

extension Date{
    func timeFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h.mm a"
        return dateFormatter.string(from: self)
    }
    
    func dateStamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d'\(daySuffix())' MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d'\(daySuffix())' MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    private func daySuffix() -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: self)
        
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    func greeting() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        
        switch hour {
        case 6..<12:
            return "Good Morning"
        case 12..<18:
            return "Good Afternoon"
        case 18..<22:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
}
