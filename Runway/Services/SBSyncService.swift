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
    private var cancelSync: Bool = false
    
    // MARK: - Init
    
    override init() {
        service = SBWebService()
        realm = try! Realm()
        
        super.init()
    }
    
    // MARK: - Actions
    
    func sync(callback callback: (error: NSError?) -> ()) {
        print("🚁 Start syncing")
        cancelSync = false
        syncPilots { error in
            print("🚁 Stop syncing")
            callback(error: error)
        }
    }
    
    func deleteData() {
        print("🚁 Delete all data")
        SBConfiguration.sharedInstance.pilotsLastUpdatedAt = nil
        try! realm.write {
            self.realm.deleteAll()
        }
    }
    
    func cancel() {
        cancelSync = true
        service.cancel()
    }
    
    // MARK: - Pilots
    
    private func syncPilots(callback callback: (error: NSError?) -> ()) {
        service.fetchPilots { response in
            if let objects = (response.data as! NSDictionary?)?["pilots"] as? [NSDictionary] {
                print("🚁 Fetched \(objects.count) pilots")
                self.updateObjects(Pilot.self, objects: objects)
                SBConfiguration.sharedInstance.pilotsLastUpdatedAt = NSDate()
                
                self.syncDeletedPilots(callback: callback)
            } else {
                callback(error: response.error)
            }
        }
    }
    
    private func syncDeletedPilots(callback callback: (error: NSError?) -> ()) {
        if cancelSync {
            callback(error: nil)
            return
        }
        
        service.fetchPilots(handleUpdatedAt: false) { response in
            if let objects = (response.data as! NSDictionary?)?["pilots"] as? [NSDictionary] {
                let ids = objects.map { $0["id"] as! Int }
                dispatch_main {
                    let pilots = Pilot.filterPilotsToDelete(ids: ids, realm: self.realm)
                    print("🚁 Fetched \(pilots.count) pilots to delete")
                    try! self.realm.write {
                        self.realm.delete(pilots)
                    }
                }
            }
            callback(error: response.error)
//            self.syncPilotImages(callback: callback)
        }
    }
    
    private func syncPilotImages(callback callback: (error: NSError?) -> ()) {
        let group = dispatch_group_create()
        
            let realm = try! Realm()
            let pilots = realm.objects(Pilot).map { $0 }
            for pilot in pilots {
                dispatch_group_enter(group)
                self.downloadPilotImage(pilot: pilot, dispatch_group: group)
            }
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
            dispatch_main {
                print("🚀 Finished downloading")
                callback(error: nil)
            }
    }
    
    private func downloadPilotImage(pilot pilot: Pilot, dispatch_group: dispatch_group_t) {
        service.fetchPilotImage(pilot) { response in
            if let data = response.data as? NSData {
                try! self.realm.write {
                    pilot.image = data
                }
            }
            dispatch_group_leave(dispatch_group)
        }
    }
    
    // MARK: - Updates
    
    func fetchUpdates(callback callback: (updatedPilots: Int) -> ()) {
        service.fetchPilots { response in
            var count = 0
            if let objects = (response.data as! NSDictionary?)?["pilots"] as? [NSDictionary] {
                count = objects.count
            }
            callback(updatedPilots: count)
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