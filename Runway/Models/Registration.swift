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
    @NSManaged var duration: NSNumber?
    @NSManaged var comment: String?
    
    // MARK: - Core Data relations
    
    @NSManaged var pilot: Pilot?
    
    // MARK: - JSON
    
    var json: [String:[String:AnyObject]] {
        return [
            "work_registration" : [
                "pilot_id" :   Int(pilot!.id),
                "started_at" : SBDateFormatter.sharedInstance.apiFormatter.stringFromDate(startedAt!),
                "duration" :   String(duration ?? 0),
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
        AERecord.saveContextAndWait(context)
    }
    
    // MARK: - Actions
    
    func stop(withComment comment: String, context: NSManagedObjectContext = AERecord.defaultContext) {
        duration = NSNumber(integer: Int(NSDate().timeIntervalSince1970 - startedAt!.timeIntervalSince1970) / 60)
        self.comment = comment
        AERecord.saveContextAndWait(context)
    }
    
    // MARK: - Queries
    
    static func registrationsInProgress(context: NSManagedObjectContext = AERecord.defaultContext) -> [Registration] {
        let predicate = NSPredicate(format: "startedAt != nil AND duration == nil")
        return registrations(fromPredicate: predicate, context: context)
    }
    
    static func nextRegistrationToUpload(context: NSManagedObjectContext = AERecord.defaultContext) -> Registration? {
        let predicate = NSPredicate(format: "startedAt != nil AND duration != nil")
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