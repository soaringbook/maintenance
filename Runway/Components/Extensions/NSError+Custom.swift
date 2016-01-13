//
//  NSError+Custom.swift
//  Runway
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
        case .Authentication: return [NSLocalizedDescriptionKey: NSLocalizedString("common_errors_service_authentication", comment: "")]
        case .Fetching:       return [NSLocalizedDescriptionKey: NSLocalizedString("common_errors_service_fetching", comment: "")]
        case .Downloading:    return [NSLocalizedDescriptionKey: NSLocalizedString("common_errors_service_image_downloading", comment: "")]
        }
    }
}

extension NSError {
    convenience init(code: RWErrorCode) {
        self.init(domain: RWErrorDomain, code: code.rawValue, userInfo: code.userInfo())
    }
}