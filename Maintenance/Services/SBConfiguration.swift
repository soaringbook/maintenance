//
//  SBConfiguration.swift
//  Soaring Book
//
//  Created by Jelle Vandenbeeck on 05/01/15.
//  Copyright (c) 2015 Fousa. All rights reserved.
//

import UIKit

class SBConfiguration: NSObject {
    
    private let SBConfigurationApiHostKey =     "API_HOST"
    private let SBConfigurationApiProtocolKey = "API_PROTOCOL"
    private let SBConfigurationApiVersionKey =  "API_VERSION"
    
    // MARK: - Getter
    
    var apiHost: NSString {
        return getConfiguration(key: SBConfigurationApiHostKey)
    }
    
    var apiProtocol: NSString {
        return getConfiguration(key: SBConfigurationApiProtocolKey)
    }
    
    var apiVersion: NSString {
        return getConfiguration(key: SBConfigurationApiVersionKey)
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
    
    private func getConfiguration(key key: NSString) -> NSString {
        return removeQuotes(self.configuration[key]! as! NSString)
    }
    
    private func removeQuotes(text: NSString) -> NSString {
        return text.stringByReplacingOccurrencesOfString("\"", withString: "")
    }
}
