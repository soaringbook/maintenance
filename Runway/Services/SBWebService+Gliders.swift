//
//  SBWebService+Gliders.swift
//  Runway
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import Foundation

extension SBWebService {
    func fetchGliders(callback callback: (SBWebServiceResponse) -> ()) {
        fetchRequest(path: "gliders.json", callback: callback)
    }
}