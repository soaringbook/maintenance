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
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    
    dynamic var imageURL: String?
    dynamic var imageData: NSData?
    dynamic var image: UIImage?
    dynamic var shouldDownloadImage: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image"]
    }
    
    var displayName: String {
        return "\(firstName) \(lastName)"
    }
    
    // MARK: - Creation
    
    static func update(fromResponse objects: [[String:AnyObject]]) {
        let realm = try! Realm()
        realm.beginWrite()
        for object in objects {
            createObject(realm: realm, object: object)
        }
        try! realm.commitWrite()
    }
    
    static func createObject(realm realm: Realm, object: [String:AnyObject]) {
        var pilotObject = object
        pilotObject["firstName"] = pilotObject.removeValueForKey("first_name")
        pilotObject["lastName"] = pilotObject.removeValueForKey("last_name")
        pilotObject["imageURL"] = pilotObject.removeValueForKey("retina_image")
        
        var shouldUpdate = pilotObject["imageURL"] != nil
        if let existingPilot = realm.objectForPrimaryKey(Pilot.self, key: pilotObject["id"]!) where shouldUpdate {
            shouldUpdate = ((existingPilot.imageData?.length ?? 0) == 0 || pilotObject["imageURL"] as? String != existingPilot.imageURL)
        }
        pilotObject["shouldDownloadImage"] = shouldUpdate
        
        realm.create(Pilot.self, value: pilotObject, update: true)
    }
    
    // MARK: - Queries
    
    static func selectablePilotsForRegistration(realm realm: Realm, query: String?) -> Results<Pilot> {
        var objects = realm.objects(Pilot)
        if let query = query {
            let filter = NSPredicate(format: "firstName contains[c] '\(query)' OR lastName contains[c] '\(query)'")
            objects = objects.filter(filter)
        }
        return objects.sorted("lastName")
    }
    
    static func filterPilotsToDelete(ids ids: [Int], realm: Realm) -> Results<Pilot> {
        let filter = NSPredicate(format: "NOT (id in %@)", ids)
        return realm.objects(Pilot).filter(filter)
    }
    
    static func filterPilotsToDownload(realm realm: Realm) -> Results<Pilot> {
        let filter = NSPredicate(format: "shouldDownloadImage == 1")
        return realm.objects(Pilot).filter(filter)
    }
}
