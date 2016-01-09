//
//  AppDelegate.swift
//  Runway
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

import AERecord
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - UIApplicationDelegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        configureFabric()
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
    
    private func configureFabric() {
        guard isDebug() else {
            // Don't use Fabric configuration in debug mode.
            return
        }
        
        printVerbose("Loading Fabric configuration.")
        
        Fabric.with([Crashlytics.self])
    }
}