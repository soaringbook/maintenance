//
//  AppDelegate.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - UIApplicationDelegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        presentSetupFlowIfNeeded()
    }
    
    // MARK: - Flow
    
    private func presentSetupFlowIfNeeded() {
        guard self.window?.rootViewController?.presentedViewController == nil else {
            // Return when a modal is already being presented.
            return
        }
        
        if SBKeychain.sharedInstance.token != nil {
            // Return when a token is set.
            return
        }
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if let controller = storyboard.instantiateInitialViewController() {
            // Use dispatch async to overcome the unbalanced warning.
            dispatch_async(dispatch_get_main_queue()) {
                self.window?.rootViewController?.presentViewController(controller, animated: false, completion: nil)
            }
        }
    }
}