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
