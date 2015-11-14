//
//  Pilot.swift
//  Runway
//
//  Created by Jelle Vandenbeeck on 02/10/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import RealmSwift

class Pilot: Object, WizardSelectionItem {
    dynamic var id: Int = 0
    dynamic var first_name: String = ""
    dynamic var last_name: String = ""
    
    dynamic var retina_image: String?
    dynamic var non_retina_image: String?
    dynamic var image: NSData?
    dynamic var shouldDownload: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var displayName: String {
        return "\(first_name) \(last_name)"
    }
    
    // MARK: - Queries
    
    static func selectablePilots(query query: String?, realm: Realm) -> Results<Pilot> {
        var objects = realm.objects(Pilot)
        if let query = query {
            let filter = NSPredicate(format: "first_name contains[c] '\(query)' OR last_name contains[c] '\(query)'")
            objects = objects.filter(filter)
        }
        return objects.sorted("last_name")
    }
    
    static func filterPilotsToDelete(ids ids: [Int], realm: Realm) -> Results<Pilot> {
        let filter = NSPredicate(format: "NOT (id in %@)", ids)
        return realm.objects(Pilot).filter(filter)
    }
}
