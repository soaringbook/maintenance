//
//  SoaringBookClient.swift
//  Runway
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import Foundation

enum SBWebServiceResponse {
    case Failure(NSError)
    case FetchSuccess(NSDictionary)
    case DownloadSuccess(NSData)
    case Authenticated
    case NotAuthenticated(NSError)
    case NotAvailable
    case Empty
    
    // Parse the result for authentication
    init(error: NSError?, response: NSHTTPURLResponse) {
        if let error = error {
            self = .Failure(error)
        } else if response.statusCode == 200 {
            self = .Authenticated
        } else {
            self = .NotAuthenticated(NSError(code: .Authentication))
        }
    }
    
    // Parse the result as URL
    init(error: NSError?, url: NSURL?) {
        if let error = error {
            self = .Failure(error)
        } else {
            if let url = url {
                let content = NSData(contentsOfURL: url)
                self = .DownloadSuccess(content!)
            } else {
                self = .Failure(NSError(code: .Downloading))
            }
        }
    }
    
    // Parse the result as JSON
    init(error: NSError?, data: NSData?) {
        if let error = error {
            self = .Failure(error)
        } else if let data = data {
            do {
                let content = try (NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary) as NSDictionary?
                self = .FetchSuccess(content!)
            } catch {
                self = .Failure(NSError(code: .Fetching))
            }
        } else {
            self = .Empty
        }
    }
    
    var error: NSError? {
        switch self {
        case .FetchSuccess(_): return nil
        case .Failure(let error): return error
        case .NotAuthenticated(let error): return error
        default: return nil
        }
    }
    
    var data: AnyObject? {
        switch self {
        case .DownloadSuccess(let data): return data
        case .FetchSuccess(let data): return data
        default: return nil
        }
    }
}

class SBWebService: NSObject {
    
    // MARK: - Privates
    
    private var session: NSURLSession
    private var sessionActive: Bool = true
    
    // MARK: - Initialization
    
    override init() {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.HTTPMaximumConnectionsPerHost = 1
        session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        super.init()
    }
    
    // MARK: - Actions
    
    func resume() {
        sessionActive = true
    }
    
    func cancel() {
        sessionActive = false
        session.invalidateAndCancel()
    }
    
    // MARK:- Authenticate
    
    func authenticate(token token: String, callback: (SBWebServiceResponse) -> ()) {
        let request = authenticatedRequest(path: "gliders.json", method: "HEAD", token: token)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let response = response as? NSHTTPURLResponse {
                let serviceResponse = SBWebServiceResponse(error: error, response: response)
                if serviceResponse.error == nil {
                    SBKeychain.sharedInstance.token = token
                }
                callback(serviceResponse)
            } else {
                callback(SBWebServiceResponse.NotAuthenticated(NSError(code: .Authentication)))
            }
        }
        task.resume()
    }
    
    // MARK: - Requests
    
    func fetchRequest(path path: String, callback: (SBWebServiceResponse) -> ()) {
        guard sessionActive else {
            // When the session is cancelled just return.
            return
        }
        
        let request = authenticatedRequest(path: path)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            callback(SBWebServiceResponse(error: error, data: data))
        }
        task.resume()
    }
    
    func fetchImageRequest(path path: String?, callback: (SBWebServiceResponse) -> ()) {
        guard sessionActive else {
            // When the session is cancelled just return.
            return
        }
        
        if let path = path {
            let request = unauthenticatedRequest(path: path)
            let task = session.downloadTaskWithRequest(request) { url, response, error in
                callback(SBWebServiceResponse(error: error, url: url))
            }
            task.resume()
        } else {
            callback(SBWebServiceResponse.NotAvailable)
        }
    }
    
    private func unauthenticatedRequest(path path: String) -> NSURLRequest {
        let URL = NSURL(string: path)
        return NSURLRequest(URL: URL!)
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