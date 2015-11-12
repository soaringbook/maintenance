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
    
    // MARK: - Init
    
    override init() {
        service = SBWebService()
        
        super.init()
    }
    
    // MARK: - Actions
    
    func sync(callback callback: (error: NSError?) -> ()) {
        syncPilots(callback: callback)
    }
    
    // MARK: - Pilots
    
    private func syncPilots(callback callback: (error: NSError?) -> ()) {
        service.fetchPilots { response in
            if let pilots = (response.data as! NSDictionary?)?["pilots"] as? [NSDictionary] {
                self.updateObjects(Pilot.self, objects: pilots)
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
        realm.commitWrite()
    }
}