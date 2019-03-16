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
    @objc dynamic public private(set) var date = Date()
    
    public private(set) var locations = List<Location>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["date", "pace", "duration" ]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = Date()
        self.pace = pace
        self.distance = distance
        self.duration = duration
        self.locations = locations
    }
    
    static func addRunToRealm(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
        REALM_QUEUE.sync {
            let run = Run(pace: pace, distance: distance, duration: duration, locations: locations)
            do {
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                try realm.write {
                    realm.add( run )
                    try realm.commitWrite()
                }
            } catch {
                debugPrint("Error adding object to realm: \(error)")
            }
        }
    }
    
    static func getAllRuns() -> Results<Run>? {
        do {
            let realm = try Realm(configuration: RealmConfig.runDataConfig)
            return realm.objects(Run.self).sorted(byKeyPath: "date", ascending: false)
        } catch {
            debugPrint("Error when getting all runs from realm: \(error)")
            return nil
        }
    }
}
