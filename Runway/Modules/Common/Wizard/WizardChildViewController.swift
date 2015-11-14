//
//  WizardChildViewController.swift
//  Soaringbook Runway
//
//  Created by Jelle Vandenbeeck on 06/01/15.
//  Copyright (c) 2015 Fousa. All rights reserved.
//

import UIKit

class WizardChildViewController: UIViewController {
    
    // MARK: - Publics
    
    var wizardViewController: WizardViewController?
    var leftConstraint: NSLayoutConstraint?
    
    // MARK: Getters
    
    var wizardTitle: NSString {
        assertionFailure("Should be overwritten set by subclass.")
        return ""
    }
    
    // MARK: - Initialization
    
    convenience init(wizardViewController: WizardViewController) {
        self.init()
        
        self.wizardViewController = wizardViewController
    }
}