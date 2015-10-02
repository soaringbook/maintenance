//
//  NSError+Custom.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 30/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import Foundation

let RWErrorDomain: String = "com.soaringbook.runway.error"

enum RWErrorCode: Int {
    case Authentication
    case Fetching
    case Downloading
    
    func userInfo() -> [NSObject : AnyObject]? {
        switch self {
        case .Authentication: return [NSLocalizedDescriptionKey: "There was a problem authenticating with the webservice."]
        case .Fetching:       return [NSLocalizedDescriptionKey: "There was a problem fetching from the webservice."]
        case .Downloading:    return [NSLocalizedDescriptionKey: "There was a problem downloading from the webservice."]
        }
    }
}

extension NSError {
    convenience init(code: RWErrorCode) {
        self.init(domain: RWErrorDomain, code: code.rawValue, userInfo: code.userInfo())
    }
}