//
//  Pilot.swift
//  Runway
//
//  Created by Jelle Vandenbeeck on 02/10/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit
import CoreData
import AERecord

class Pilot: NSManagedObject, WizardSelectionItem {
    
    // MARK: - Core Data properties
    
    @NSManaged var id: Int64
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var imageURL: String?
    @NSManaged var imageData: NSData?
    @NSManaged var shouldDownloadImage: Bool

    // MARK: - Transient properties
    
    var image: UIImage?
    
    // MARK: - Utilties
    
    var displayName: String {
        return "\(firstName) \(lastName)"
    }
    
    // MARK: - Creation
    
    static func update(fromResponse objects: [[String:AnyObject]]) {
//        let realm = try! Realm()
//        realm.beginWrite()
//        for object in objects {
//            createObject(object: object)
//        }
//        try! realm.commitWrite()
    }
    
//    static func createObject(object: [String:AnyObject], context: NSManagedObjectContext? = AERecord.mainContext) {
//        var pilotObject = object
//        pilotObject["firstName"] = pilotObject.removeValueForKey("first_name")
//        pilotObject["lastName"] = pilotObject.removeValueForKey("last_name")
//        pilotObject["imageURL"] = pilotObject.removeValueForKey("retina_image")
//        
//        var shouldUpdate = pilotObject["imageURL"] != nil
//        if let existingPilot = realm.objectForPrimaryKey(Pilot.self, key: pilotObject["id"]!) where shouldUpdate {
//            shouldUpdate = ((existingPilot.imageData?.length ?? 0) == 0 || pilotObject["imageURL"] as? String != existingPilot.imageURL)
//        }
//        pilotObject["shouldDownloadImage"] = shouldUpdate
//        
//        realm.create(Pilot.self, value: pilotObject, update: true)
//    }
    
    // MARK: - Deleting
    
    static func deleteUnkownPilots(ids ids: [Int], context: NSManagedObjectContext = AERecord.mainContext) {
        let predicate = NSPredicate(format: "NOT (id in %@)", ids)
        deleteAllWithPredicate(predicate, context: context)
    }

    // MARK: - Queries
    
    static func selectablePilotsForRegistration(query: String?, context: NSManagedObjectContext = AERecord.mainContext) -> [Pilot] {
//        if let query = query {
//            let filter = NSPredicate(format: "firstName contains[c] '\(query)' OR lastName contains[c] '\(query)'")
//            objects = objects.filter(filter)
//        }
//        return objects.sorted("lastName")
        return [Pilot]()
    }
    
    static func fetchNextPilotToDownload(context: NSManagedObjectContext = AERecord.mainContext) -> Pilot? {
        let predicate = NSPredicate(format: "shouldDownloadImage == 1")
        let descriptors = [
            NSSortDescriptor(key: "lastName", ascending: true),
            NSSortDescriptor(key: "firstName", ascending: true)
        ]
        return firstWithPredicate(predicate, sortDescriptors: descriptors, context: context) as! Pilot?
    }
}
