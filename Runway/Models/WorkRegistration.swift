//
//  WorkRegistration.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 14/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import CoreData
import AERecord

class WorkRegistration: NSManagedObject  {
    
    // MARK: - Core Data properties
    
    @NSManaged var startedAt: NSDate?
    @NSManaged var endedAt: NSDate?
    
    // MARK: - Core Data relations
    
    @NSManaged var pilot: Pilot?
    
    // MARK: - Creation
    
    static func create(fromPilot pilot: Pilot, context: NSManagedObjectContext? = AERecord.mainContext) -> WorkRegistration {
//        let registration = WorkRegistration(value: ["pilot" : pilot])
//        try! realm.write {
//            realm.add(registration)
//        }
//        return registration
        return WorkRegistration()
    }
    
    // MARK: - Queries
    
    static func registrationsInProgress(context: NSManagedObjectContext? = AERecord.mainContext) -> [WorkRegistration] {
//        return realm.objects(WorkRegistration)
        return [WorkRegistration]()
    }
}