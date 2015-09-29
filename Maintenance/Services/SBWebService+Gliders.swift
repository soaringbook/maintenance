//
//  SBWebService+Gliders.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import Foundation

extension SBWebService {
    func fetchGliders(callback callback: (SBWebServiceError?, AnyObject?) -> ()) {
        fetchRequest(path: "gliders.json") { error, data in
            callback(error, data)
        }
    }
}
