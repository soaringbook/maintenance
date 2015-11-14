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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var displayName: String {
        return "\(first_name) \(last_name)"
    }
    
    // MARK: - Queries
    
    static func selectablePilots(realm realm: Realm) -> Results<Pilot> {
        return realm.objects(Pilot).sorted("last_name")
    }
    
    static func filterPilotsToDelete(ids ids: [Int], realm: Realm) -> Results<Pilot> {
        let filter = NSPredicate(format: "NOT (id in %@)", ids)
        return realm.objects(Pilot).filter(filter)
    }
}