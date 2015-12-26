//
//  SBDefaults.swift
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015. All rights reserved.
//

import Foundation

class SBDefaults: NSUserDefaults {
    
    // This user default value is used to indicate if we want to read the value from
    // the keychain. We do not want this when the application is installed again.
    private static let SBDefaultsUseKeychainKey = "SBDefaultsUseKeychainKey"
    
    // MARK: - Overrides
    
    static var useKeychain: Bool {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.synchronize()
            return defaults.boolForKey(SBDefaultsUseKeychainKey) ?? false
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(newValue, forKey: SBDefaultsUseKeychainKey)
            defaults.synchronize()
        }
    }
}