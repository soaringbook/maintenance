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
    
    // MARK: - Core Data relations
    
    @NSManaged var pilot: Pilot?
    
    // MARK: - Creation
    
    static func start(fromPilot pilot: Pilot, context: NSManagedObjectContext = AERecord.defaultContext) -> Registration {
        let registration = Registration.create(context: context)
        registration.pilot = pilot
        registration.startedAt = NSDate()
        AERecord.saveContextAndWait(context)
        
        return registration
    }
    
    // MARK: - Queries
    
    static func registrationsInProgress(context: NSManagedObjectContext = AERecord.defaultContext) -> [Registration] {
        let predicate = NSPredicate(format: "startedAt != nil AND endedAt == nil")
        let descriptors = [
            NSSortDescriptor(key: "startedAt", ascending: false)
        ]
        return allWithPredicate(predicate, sortDescriptors: descriptors, context: context) as! [Registration]? ?? [Registration]()
    }
}