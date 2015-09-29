//
//  UIAlertController+Errors.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    convenience init(error: SBWebServiceError) {
        self.init(title: "An error occured", message: "error message", preferredStyle: .Alert)
    }
    
}