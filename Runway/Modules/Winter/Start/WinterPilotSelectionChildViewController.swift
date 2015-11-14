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
    
    override var selectionItems: [WizardSelectionItem] {
        let realm = try! Realm()
        return Pilot.selectablePilots(realm: realm).map { $0 }
    }
    
    // MARK: - Data
    
    override func selectItem(item: WizardSelectionItem) {
        print("👱 Selected \(item.displayName)")
    }
}
