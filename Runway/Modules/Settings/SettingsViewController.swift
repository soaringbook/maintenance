//
//  SettingsViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 11/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
        return nil
    }
}
