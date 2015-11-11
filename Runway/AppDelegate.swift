//
//  AppDelegate.swift
//  Runway
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginViewControllerDelegate {

    var window: UIWindow?
    
    // MARK: - UIApplicationDelegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        presentLoginFlowIfNeeded()
    }
    
    // MARK: - LoginViewControllerDelegate
    
    func loginViewControllerWillDismiss(controller: LoginViewController) {
        self.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Flow
    
    private func shouldPresentLogin() -> Bool {
        return SBKeychain.sharedInstance.token == nil
    }
    
    private func presentLoginFlowIfNeeded() {
//        guard self.window?.rootViewController?.presentedViewController == nil else {
//            // Return when a modal is already being presented.
//            return
//        }
//
//        guard shouldPresentLogin() else {
//            // Return when a token is set.
//            return
//        }
//        
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        if let controller = storyboard.instantiateInitialViewController() as? LoginViewController {
//            controller.delegate = self
//            // Use dispatch async to overcome the unbalanced warning.
//            dispatch_main {
//                self.window?.rootViewController?.presentViewController(controller, animated: false, completion: nil)
//            }
//        }
    }
}