//
//  Extensions.swift
//  Threads
//
//  Created by Artur Ratajczak on 10/03/2019.
//  Copyright © 2019 Artur Ratajczak. All rights reserved.
//

import Foundation

extension Double {
    func metersToKilometers( places: Int ) -> Double {
        let divisor = pow(10.0, Double(places))
        return  ( ( self / 1000 ) * divisor ).rounded() / divisor
    }
}

extension Int {
    func formatTimeDurationToString() -> String {
        let durationHours = self / 3600
        let durationMinutes = ( self % 3600 ) / 60
        let durationSeconds = ( self % 3600 ) % 60
        
        if durationSeconds < 0 {
            return "00:00:00"
        } else {
            if durationHours == 0 {
                return String(format: "%02d:%02d", durationMinutes, durationSeconds)
            } else {
                return String(format: "%02d:%02d:%02d", durationHours, durationMinutes, durationSeconds)
            }
        }
    }
}

extension Date {
    func getDateString() -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        
        return "\(day)/\(month)/\(year)"
    }
}
