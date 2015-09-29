//
//  SBKeychain.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import Foundation
import KeychainAccess

class SBKeychain: NSObject {
    
    private let SBTokenKey = "soaring_book_token_key"
    
    private let keychain = Keychain(service: "com.soaringbook.maintenance")
    
    // MARK: - Getter
    
    var token: String? {
        get {
            do {
                return try keychain.get(SBTokenKey)
            } catch {
                return nil
            }
        }
        set {
            do {
                if let newValue = newValue {
                    return try keychain.set(newValue, key: SBTokenKey)
                } else {
                    return try keychain.remove(SBTokenKey)
                }
            } catch {
                
            }
        }
    }
    
    // MARK: - Initialization
    
    class var sharedInstance: SBKeychain {
        struct StaticSBKeychain {
            static let instance : SBKeychain = SBKeychain()
        }
        return StaticSBKeychain.instance
    }
}