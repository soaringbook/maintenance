//
//  SBConfiguration.swift
//  Soaring Book
//
//  Created by Jelle Vandenbeeck on 05/01/15.
//  Copyright (c) 2015 Fousa. All rights reserved.
//

import UIKit

class SBConfiguration: NSObject {
    
    private let SBConfigurationApiHostKey =             "API_HOST"
    private let SBConfigurationApiProtocolKey =         "API_PROTOCOL"
    private let SBConfigurationApiVersionKey =          "API_VERSION"
    private let SBConfigurationHockeyAppIdentifierKey = "HOCKEY_APP_IDENTIFIER"
    private let SBConfigurationPilotsLastUpdatedAtKey = "PILOTS_LAST_UPDATED_AT"
    
    // MARK: - Getter
    
    var apiHost: String {
        return getConfiguration(key: SBConfigurationApiHostKey)
    }
    
    var apiProtocol: String {
        return getConfiguration(key: SBConfigurationApiProtocolKey)
    }
    
    var apiVersion: String {
        return getConfiguration(key: SBConfigurationApiVersionKey)
    }
    
    var hockeyAppIdentifier: String {
        return getConfiguration(key: SBConfigurationHockeyAppIdentifierKey)
    }
    
    var pilotsLastUpdatedAt: NSDate? {
        get {
            return fetchUpdatedAt(key: SBConfigurationPilotsLastUpdatedAtKey)
        }
        set {
            storeUpdatedAt(key: SBConfigurationPilotsLastUpdatedAtKey, date: newValue)
        }
    }
    
    // MARK: Privates
    
    private var configuration: [NSObject : AnyObject]!
    
    // MARK: - Initialization
    
    class var sharedInstance: SBConfiguration {
        struct StaticSBConfiguration {
            static let instance : SBConfiguration = SBConfiguration()
        }
        return StaticSBConfiguration.instance
    }
    
    override init() {
        self.configuration = NSBundle.mainBundle().infoDictionary
        
        super.init()
    }
    
    // MARK: - Utilies
    
    private func getConfiguration(key key: String) -> String {
        return removeQuotes(self.configuration[key]! as! String)
    }
    
    private func removeQuotes(text: String) -> String {
        return (text as NSString).stringByReplacingOccurrencesOfString("\"", withString: "")
    }
    
    // MARK: - Updated at
    
    private func storeUpdatedAt(key key: String, date: NSDate?) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let date = date {
            defaults.setObject(date, forKey: key as String)
        } else {
            defaults.removeObjectForKey(key as String)
        }
        defaults.synchronize()
    }
    
    private func fetchUpdatedAt(key key: String) -> NSDate? {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.synchronize()
        return defaults.objectForKey(key) as! NSDate?
    }
}
