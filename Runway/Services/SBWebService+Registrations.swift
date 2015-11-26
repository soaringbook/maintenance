//
//  SBWebService+Registrations.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 26/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import Foundation

extension SBWebService {
    func upload(registration registration: Registration,  callback: (SBWebServiceResponse) -> ()) {
        let path = "work_registrations.json"
        createRequest(path: path, body: registration.json, callback: callback)
    }
}