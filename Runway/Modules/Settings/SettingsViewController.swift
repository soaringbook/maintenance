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
    
    // MARK: - Actions
    
    @IBAction func disconnect(sender: AnyObject) {
        SBKeychain.sharedInstance.token = nil
        performSegueWithIdentifier("Disconnect", sender: nil)
    }
    
    @IBAction func synchronise(sender: AnyObject) {
        
    }
    
    // MARK: - Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
