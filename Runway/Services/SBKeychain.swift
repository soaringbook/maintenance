//
//  SBKeychain.swift
//  Runway
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import Foundation
import SSKeychain

class SBKeychain: NSObject {
    
    private let SBTokenService = "token.service"
    private let SBAccountName = "com.soaringbook.runway"
    
    // MARK: - Getter
    
    var token: String? {
        get {
            guard SBDefaults.useKeychain else {
                return nil
            }
            return SSKeychain.passwordForService(SBTokenService, account: SBAccountName)
        }
        set {
            SBDefaults.useKeychain = true
            if let newValue = newValue {
                SSKeychain.setPassword(newValue, forService: SBTokenService, account: SBAccountName)
            } else {
                SSKeychain.deletePasswordForService(SBTokenService, account: SBAccountName)
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