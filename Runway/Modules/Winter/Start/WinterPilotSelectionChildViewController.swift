//
//  WinterPilotSelectionChildViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 14/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class WinterPilotSelectionChildViewController: WizardChildSelectionViewController, WinterStartViewControllerDelegate {
    
    var actionTransitioningDelegate: ActionTransitioningDelegate?
    
    var selectedPilot: Pilot?
        
    // MARK: Getters
    
    override var wizardTitle: String {
        return NSLocalizedString("work_labels_start_title", comment: "")
    }
    
    override var searchPlaceholderTitle: String {
        return NSLocalizedString("work_labels_start_search_placeholder", comment: "")
    }
    
    // MARK: - Data
    
    override func reloadData(query query: String? = nil) {
        self.selectionItems = Pilot.selectablePilotsForRegistration(query)
    }
    
    override func selectItem(item: WizardSelectionItem) {
        let controller = WinterStartViewController(withItem: item)
        controller.delegate = self
        let actionViewController = ActionViewController(withController: controller)
        presentViewController(actionViewController, animated: true, completion: nil)
    }
    
    // MARK: - WinterStartViewControllerDelegate
    
    func winterStartViewController(controller: WinterStartViewController, didStartItem item: WizardSelectionItem) {
        if let item = item as? Pilot {
            self.selectedPilot = item
            self.wizardViewController?.presentNextController()
        }
    }
    
    func winterStartViewControllerDidCancel(controller: WinterStartViewController) {
        searchField?.becomeFirstResponder()
    }
}