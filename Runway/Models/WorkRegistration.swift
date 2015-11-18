//
//  WorkRegistration.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 14/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import RealmSwift

class WorkRegistration: Object  {
    dynamic var pilot: Pilot?
    
    // MARK: - Creation
    
    static func create(fromPilot pilot: Pilot, realm: Realm) -> WorkRegistration {
        let registration = WorkRegistration(value: ["pilot" : pilot])
        try! realm.write {
            realm.add(registration)
        }
        return registration
    }
    
    // MARK: - Queries
    
    static func registrationsInProgress(realm realm: Realm) -> Results<WorkRegistration> {
        return realm.objects(WorkRegistration)
    }
}