//
//  WinterViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 14/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class WinterViewController: UIViewController {
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? WizardViewController where segue.identifier == "Start" {
            controller.type = WizardType.WinterRegistration
        }
    }

    // MARK: - Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}