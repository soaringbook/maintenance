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
    
    // MARK: - Core Data relationships
    
    @NSManaged var registrations: NSSet

    // MARK: - Transient properties
    
    var image: UIImage?
    
    // MARK: - Utilties
    
    var displayName: String {
        let components = [firstName, lastName].flatMap { $0 }
        return components.joinWithSeparator(" ")
    }
    
    // MARK: - Creation
    
    static func updateObjects(fromResponse objects: [[String:AnyObject]], context: NSManagedObjectContext = AERecord.defaultContext) {
        for object in objects {
            updateObject(fromResponse: object, context: context)
        }
    }
    
    static func updateObject(fromResponse object: [String:AnyObject], context: NSManagedObjectContext = AERecord.defaultContext) {
        let pilot = firstOrCreateWithAttribute("id", value: object["id"] as! Int, context: context) as! Pilot
        pilot.updateObject(fromResponse: object)
        AERecord.saveContextAndWait(context)
    }
    
    func updateObject(fromResponse object: [String:AnyObject]) {
        firstName           = object["first_name"] as! String?
        lastName            = object["last_name"] as! String?
        imageURL            = object["retina_image"] as! String?
        shouldDownloadImage = object["retina_image"] != nil
            && (imageData == nil || imageURL != object["retina_image"] as! String?)
    }
    
    // MARK: - Deleting
    
    static func deleteUnkownPilots(ids ids: [Int], context: NSManagedObjectContext = AERecord.defaultContext) {
        let predicate = NSPredicate(format: "NOT (id in %@)", ids)
        deleteAllWithPredicate(predicate, context: context)
    }

    // MARK: - Queries
    
    static func selectablePilotsForRegistration(query: String?, context: NSManagedObjectContext = AERecord.defaultContext) -> [Pilot] {
        var predicate = NSPredicate(format: "(SUBQUERY(registrations, $registration, $registration.endedAt == nil).@count == 0 OR registrations.@count == 0)")
        if let query = query {
            let queryPredicate = NSPredicate(format: "firstName contains[c] '\(query)' OR lastName contains[c] '\(query)'")
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, queryPredicate])
        }
        let descriptors = [
            NSSortDescriptor(key: "lastName", ascending: true),
            NSSortDescriptor(key: "firstName", ascending: true)
        ]
        return allWithPredicate(predicate, sortDescriptors: descriptors, context: context) as! [Pilot]? ?? [Pilot]()
    }
    
    static func nextPilotToDownload(context: NSManagedObjectContext = AERecord.defaultContext) -> Pilot? {
        let predicate = NSPredicate(format: "shouldDownloadImage == 1")
        let descriptors = [
            NSSortDescriptor(key: "lastName", ascending: true),
            NSSortDescriptor(key: "firstName", ascending: true)
        ]
        return firstWithPredicate(predicate, sortDescriptors: descriptors, context: context) as! Pilot?
    }
}
