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
        syncPilots { error in
            print("🚁 Stop syncing")
            callback(error: error)
        }
    }
    
    func deleteData() {
        print("🚁 Delete all data")
        SBConfiguration.sharedInstance.pilotsLastUpdatedAt = nil
        AERecord.truncateAllData()
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
                Pilot.update(fromResponse: objects)
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
        if let pilot = Pilot.fetchNextPilotToDownload() {
            print("🚁 Download \(pilot.displayName)'s image")
            self.downloadPilotImage(pilot: pilot) {
                self.syncNextPilotImage(callback: callback)
            }
        } else {
            callback(error: nil)
        }
    }
    
    private func downloadPilotImage(pilot pilot: Pilot, callback: () -> ()) {
        service.fetchPilotImage(pilot) { response in
            if let data = response.data as? NSData {
                pilot.imageData = data
                pilot.shouldDownloadImage = false
                AERecord.saveContextAndWait()
            }
            callback()
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
}