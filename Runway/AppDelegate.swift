//
//  AppDelegate.swift
//  Runway
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit
import AERecord
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - UIApplicationDelegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        configureHockeyApp()
        configureCoreData()
        
        return true
    }
    
    // MARK: - Core Data
    
    private func configureCoreData() {
        do {
            try AERecord.loadCoreDataStack()
        } catch {
            printError("Failed to load the Core Data stack.")
        }
    }
    
    // MARK: - HockeyApp
    
    private func configureHockeyApp() {
        guard isDebug() else {
            // Don't use hockey app configuration in debug mode.
            return
        }
        
        printVerbose("Loading HockeyApp configuration.")
        
        BITHockeyManager.sharedHockeyManager().configureWithIdentifier(SBConfiguration.sharedInstance.hockeyAppIdentifier)
        BITHockeyManager.sharedHockeyManager().startManager()
        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()
        BITHockeyManager.sharedHockeyManager().crashManager.crashManagerStatus = .AutoSend
    }
}