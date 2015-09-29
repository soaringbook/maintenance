//
//  SoaringBookClient.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import Foundation

enum SBWebServiceError: ErrorType {
    case Failure
    case Unauthenticated
}

class SBWebService: NSObject {
    
    // MARK: - Privates
    
    private var session: NSURLSession
    
    // MARK: - Initialization
    
    override init() {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.HTTPMaximumConnectionsPerHost = 1
        session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        super.init()
    }
    
    // MARK: - Actions
    
    func cancel() {
        session.invalidateAndCancel()
    }
    
    // MARK:- Authenticate
    
    func authenticate(token token: String, callback: (SBWebServiceError?) -> ()) {
        let request = authenticatedRequest(path: "gliders.json", method: "HEAD", token: token)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let response = response as? NSHTTPURLResponse where response.statusCode == 200 {
                SBKeychain.sharedInstance.token = token
                callback(nil)
            } else {
                callback(.Unauthenticated)
            }
        }
        task.resume()
    }
    
    // MARK: - Requests
    
    func fetchRequest(path path: String, callback: (SBWebServiceError?, AnyObject?) -> ()) {
        let request = authenticatedRequest(path: path)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            if let _ = error {
                callback(.Failure, nil)
            } else {
                do {
                    let data = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves)
                    callback(nil, data)
                } catch {
                    callback(.Failure, nil)
                }
            }
        })
        task.resume()
    }
    
    private func authenticatedRequest(path path: String, method: String = "GET", token: String? = nil) -> NSMutableURLRequest {
        let hostProtocol = SBConfiguration.sharedInstance.apiProtocol
        let host = SBConfiguration.sharedInstance.apiHost
        let URL = NSURL(string: "\(hostProtocol)://\(host)/api/\(path)")
        
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = method
        
        let tokenToEncode = token ?? SBKeychain.sharedInstance.token ?? ""
        request.addValue("Token token=\(tokenToEncode)", forHTTPHeaderField: "Authorization")
        request.addValue("application/vnd.soaringbook.v\(SBConfiguration.sharedInstance.apiVersion)", forHTTPHeaderField: "Accept")
        
        return request
    }
}