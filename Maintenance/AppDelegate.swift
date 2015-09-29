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
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        presentIntialFlow()
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        presentLoginFlowIfNeeded()
    }
    
    // MARK: - Flow
    
    private func storyboardName() -> String {
        return SBKeychain.sharedInstance.token == nil ? "Login" : "Gliders"
    }
    
    private func presentIntialFlow() {
        let storyboard = UIStoryboard(name: storyboardName(), bundle: nil)
        if let controller = storyboard.instantiateInitialViewController() {
            self.window?.rootViewController = controller
        }
    }
    
    private func presentLoginFlowIfNeeded() {
        let isLoginPresented = self.window?.rootViewController is LoginViewController
        guard !isLoginPresented else {
            return
        }
        
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