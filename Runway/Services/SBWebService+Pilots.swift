//
//  SBWebService+Pilots.swift
//  Runway
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import Foundation

extension SBWebService {
    func fetchPilots(callback callback: (SBWebServiceResponse) -> ()) {
        var path = "pilots.json"
        if let updatedAt = SBConfiguration().pilotsLastUpdatedAt {
            let formattedUpdatedAt = SBDateFormatter.sharedInstance.apiFormatter.stringFromDate(updatedAt)
            path = "\(path)?last_updated_at=\(formattedUpdatedAt)"
        }
        fetchRequest(path: path, callback: callback)
    }
}