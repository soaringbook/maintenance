//
//  SettingsViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 11/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var syncLabel: UILabel!
    
    private let service: SBSyncService = SBSyncService()
    
    // MARK: - View
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        service.cancel()
    }
    
    // MARK: - Actions
    
    @IBAction func disconnect(sender: AnyObject) {
        SBKeychain.sharedInstance.token = nil
        SBSyncService().deleteData()
        performSegueWithIdentifier("Disconnect", sender: nil)
    }
    
    @IBAction func synchronise(sender: AnyObject) {
        service.sync { error in
            print("🏁")
        }
    }
    
    // MARK: - Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
