//
//  WinterPilotSelectionChildViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 14/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class WinterPilotSelectionChildViewController: WizardChildSelectionViewController {
    
    var selectedPilot: Pilot?
        
    // MARK: Getters
    
    override var wizardTitle: String {
        return "Who are you?"
    }
    
    override var searchPlaceholderTitle: String {
        return "Search for a pilot"
    }
    
    // MARK: - Data
    
    override func reloadData(query query: String? = nil) {
        self.selectionItems = Pilot.selectablePilotsForRegistration(query)
    }
    
    override func selectItem(item: WizardSelectionItem) {
        let alertController = UIAlertController(title: "Start", message: "You just indicated that \(item.displayName) is going to start working.\n\nAre you sure?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: .Default) { action in
            self.selectedPilot = item as? Pilot
            self.wizardViewController?.presentNextController()
        })
        presentViewController(alertController, animated: true, completion: nil)
    }
}