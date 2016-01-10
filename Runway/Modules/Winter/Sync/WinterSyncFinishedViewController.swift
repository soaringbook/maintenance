//
//  WinterSyncFinishedViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 10/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

class WinterSyncFinishedViewController: UIViewController, ActionViewControllerDelegate {
    
    // MARK: - Actions
    
    @IBAction func dismiss(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - ActionViewControllerDelegate
    
    var image: UIImage? {
        get {
            return UIImage(named: "Watch")
        }
    }

}
