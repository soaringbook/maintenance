//
//  SBSyncService.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 12/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import Foundation
import RealmSwift

class SBSyncService: NSObject {
    
    private let service: SBWebService
    private let realm: Realm
    
    // MARK: - Init
    
    override init() {
        service = SBWebService()
        realm = try! Realm()
        
        super.init()
    }
    
    // MARK: - Actions
    
    func sync(callback callback: (error: NSError?) -> ()) {
        print("🚁 Start syncing")
        syncPilots { error in
            print("🚁 Stop syncing")
        }
    }
    
    func deleteData() {
        print("🚁 Delete all data")
        SBConfiguration.sharedInstance.pilotsLastUpdatedAt = nil
        try! realm.write {
            self.realm.deleteAll()
        }
    }
    
    // MARK: - Pilots
    
    private func syncPilots(callback callback: (error: NSError?) -> ()) {
        service.fetchPilots { response in
            if let pilots = (response.data as! NSDictionary?)?["pilots"] as? [NSDictionary] {
                print("🚁 Fetched \(pilots.count) pilots")
                self.updateObjects(Pilot.self, objects: pilots)
                SBConfiguration.sharedInstance.pilotsLastUpdatedAt = NSDate()
            }
            callback(error: response.error)
        }
    }
    
    // MARK: - Importing
    
    private func updateObjects<T: Object>(type: T.Type, objects: [AnyObject]) {
        let realm = try! Realm()
        realm.beginWrite()
        for object in objects {
            realm.create(type, value: object, update: true)
        }
        try! realm.commitWrite()
    }
}