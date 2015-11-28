//
//  WorkRegistration.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 14/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import CoreData
import AERecord

class Registration: NSManagedObject  {
    
    // MARK: - Core Data properties
    
    @NSManaged var startedAt: NSDate?
    @NSManaged var endedAt: NSDate?
    @NSManaged var comment: String?
    
    // MARK: - Core Data relations
    
    @NSManaged var pilot: Pilot?
    
    // MARK: - JSON
    
    var json: [String:[String:AnyObject]] {
        return [
            "work_registration" : [
                "pilot_id" :   Int(pilot!.id),
                "started_at" : SBDateFormatter.sharedInstance.apiFormatter.stringFromDate(startedAt!),
                "ended_at" :   SBDateFormatter.sharedInstance.apiFormatter.stringFromDate(endedAt!),
                "comment" :    comment ?? ""
            ]
        ]
    }
    
    // MARK: - Creation
    
    static func start(fromPilot pilot: Pilot, context: NSManagedObjectContext = AERecord.defaultContext) -> Registration {
        let registration = Registration.create(context: context)
        registration.pilot = pilot
        registration.startedAt = NSDate()
        AERecord.saveContextAndWait(context)
        
        return registration
    }
    
    // MARK: - Deleting
    
    func deleteRegistration(context context: NSManagedObjectContext = AERecord.defaultContext) {
        deleteFromContext(context)
    }
    
    // MARK: - Actions
    
    func stop(context context: NSManagedObjectContext = AERecord.defaultContext) {
        endedAt = NSDate()
        AERecord.saveContextAndWait(context)
    }
    
    // MARK: - Queries
    
    static func registrationsInProgress(context: NSManagedObjectContext = AERecord.defaultContext) -> [Registration] {
        let predicate = NSPredicate(format: "startedAt != nil AND endedAt == nil")
        return registrations(fromPredicate: predicate, context: context)
    }
    
    static func nextRegistrationToUpload(context: NSManagedObjectContext = AERecord.defaultContext) -> Registration? {
        let predicate = NSPredicate(format: "startedAt != nil AND endedAt != nil")
        let descriptors = [
            NSSortDescriptor(key: "startedAt", ascending: false)
        ]
        return firstWithPredicate(predicate, sortDescriptors: descriptors, context: context) as! Registration?
    }
    
    private static func registrations(fromPredicate predicate: NSPredicate, context: NSManagedObjectContext = AERecord.defaultContext) -> [Registration] {
        let descriptors = [
            NSSortDescriptor(key: "startedAt", ascending: false)
        ]
        return allWithPredicate(predicate, sortDescriptors: descriptors, context: context) as! [Registration]? ?? [Registration]()
    }
}