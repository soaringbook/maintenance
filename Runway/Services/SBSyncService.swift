//
//  SBSyncService.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 12/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import Foundation
import CoreData
import AERecord

class SBSyncService: NSObject {
    
    private let service: SBWebService
    private var cancelSync: Bool = false
    
    // MARK: - Init
    
    override init() {
        service = SBWebService()
        
        super.init()
    }
    
    // MARK: - Actions
    
    func sync(callback callback: (error: NSError?) -> ()) {
        print("🚁 Start syncing")
        cancelSync = false
        service.resume()
        syncPilots { error in
            print("🚁 Stop syncing")
            callback(error: error)
        }
    }
    
    func cancel() {
        cancelSync = true
        service.cancel()
    }
    
    // MARK: - Pilots
    
    private func syncPilots(callback callback: (error: NSError?) -> ()) {
        service.fetchPilots { response in
            if let objects = (response.data as! NSDictionary?)?["pilots"] as? [[String:AnyObject]] {
                print("🚁 Fetched \(objects.count) pilots")
                Pilot.updateObjects(fromResponse: objects)
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
                Pilot.deleteUnkownPilots(ids: ids)
                print("🚁 Deleted unkown pilots")
            }
            self.syncNextPilotImage(callback: callback)
        }
    }
    
    private func syncNextPilotImage(callback callback: (error: NSError?) -> ()) {
        if let pilot = Pilot.nextPilotToDownload() {
            print("🚁 Download \(pilot.displayName)'s image")
            self.downloadPilotImage(pilot: pilot) { error in
                self.syncNextPilotImage(callback: callback)
            }
        } else {
            syncNextRegistration(callback: callback)
        }
    }
    
    private func downloadPilotImage(pilot pilot: Pilot, callback: (error: NSError?) -> ()) {
        service.fetchPilotImage(pilot) { response in
            if let data = response.data as? NSData {
                pilot.imageData = data
                pilot.shouldDownloadImage = false
                AERecord.saveContextAndWait()
            }
            callback(error: response.error)
        }
    }
    
    // MARK: - Registrations
    
    private func syncNextRegistration(callback callback: (error: NSError?) -> ()) {
        if let registration = Registration.nextRegistrationToUpload() {
            print("🚁 Upload \(registration.pilot?.displayName)'s registration")
            service.upload(registration: registration) { response in
                if let error = response.error {
                    callback(error: error)
                } else {
                    print("💾 Delete \(registration.pilot?.displayName)'s registration")
                    registration.deleteRegistration()
                    self.syncNextRegistration(callback: callback)
                }
            }
        } else {
            callback(error: nil)
        }
    }
    
    // MARK: - Updates
    
    func fetchUpdates(callback callback: (success: Bool, updatedPilots: Int) -> ()) {
        print("🚁 Fetching updates")
        service.fetchPilots { response in
            var count = 0
            var success = false
            if let objects = (response.data as! NSDictionary?)?["pilots"] as? [NSDictionary] {
                count = objects.count
                success = true
            }
            callback(success: success, updatedPilots: count)
        }
    }
}