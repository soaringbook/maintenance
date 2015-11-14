//
//  WinterPilotSelectionChildViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 14/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit
import RealmSwift

class WinterPilotSelectionChildViewController: WizardChildSelectionViewController {
    
    // MARK: Getters
    
    override var wizardTitle: String {
        return "Who are you?"
    }
    
    override var searchPlaceholderTitle: String {
        return "Search for a pilot"
    }
    
    // MARK: - Data
    
    override func reloadData(query query: String? = nil) {
        let realm = try! Realm()
        self.selectionItems = Pilot.selectablePilots(query: query, realm: realm).map { $0 }
    }
    
    override func selectItem(item: WizardSelectionItem) {
        wizardViewController?.presentNextController()
    }
}
