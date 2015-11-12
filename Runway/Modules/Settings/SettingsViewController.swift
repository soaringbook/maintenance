//
//  SettingsViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 11/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Actions
    
    @IBAction func disconnect(sender: AnyObject) {
        SBKeychain.sharedInstance.token = nil
        performSegueWithIdentifier("Disconnect", sender: nil)
    }
    
    // MARK: - Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
