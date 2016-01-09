//
//  SBDateFormatter.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 12/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class SBDateFormatter: NSObject {
    
    // MARK: - Read only
    
    private(set) internal var apiFormatter: NSDateFormatter = NSDateFormatter()
    
    // MARK: - Initialization
    
    class var sharedInstance: SBDateFormatter {
        struct StaticSBDateFormatter {
            static let instance : SBDateFormatter = SBDateFormatter()
        }
        return StaticSBDateFormatter.instance
    }
    
    override init() {
        super.init()
        
        apiFormatter.dateFormat = "yyyy-MM-dd"
        apiFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
    }
}

