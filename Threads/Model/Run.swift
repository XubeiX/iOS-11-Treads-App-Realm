//
//  Run.swift
//  Threads
//
//  Created by Artur Ratajczak on 16/03/2019.
//  Copyright © 2019 Artur Ratajczak. All rights reserved.
//

import Foundation
import RealmSwift

class Run : Object {
    @objc dynamic public private(set) var id = ""
    @objc dynamic public private(set) var pace = 0
    @objc dynamic public private(set) var distance = 0.0
    @objc dynamic public private(set) var duration = 0
    @objc dynamic public private(set) var date = NSData()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["date", "pace", "duration" ]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSData()
        self.pace = pace
        self.distance = distance
        self.duration = duration
    }
}
