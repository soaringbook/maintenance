//
//  WinterViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 14/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit
import RealmSwift

private let SelectionCellSpacing: CGFloat = 10.0
private let CollectionViewSpacing: CGFloat = 20.0

class WinterViewController: UIViewController, WizardViewControllerDateSource, WizardViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    private let realm = try! Realm()
    private lazy var registrationItems: Results<WorkRegistration> = {
        [unowned self] in
        return WorkRegistration.registrationsInProgress(realm: self.realm)
    }()
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(UINib(nibName: "WizardChildImageSelectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(0.0, 30.0, 30.0, 30.0)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? WizardViewController where segue.identifier == "Start" {
            controller.dataSource = self
            controller.delegate = self
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return registrationItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! WizardChildImageSelectionViewCell
        let item = registrationItems[indexPath.item]
        cell.configure(item: item.pilot!)
        return cell
    }
    
    // MARK: - WizardViewControllerDateSource
    
    func controllersForWizard(controller: WizardViewController) -> [WizardChildViewController] {
        return [
            WinterPilotSelectionChildViewController(wizardViewController: controller)
        ]
    }
    
    // MARK: - WizardViewControllerDelegate
    
    func wizardControllerShouldDismiss(controller: WizardViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func wizardControllerWillComplete(controller: WizardViewController, fromController: WizardChildViewController) {
        if let fromController = fromController as? WinterPilotSelectionChildViewController, let pilot = fromController.selectedPilot {
            startTimeRegistration(forPilot: pilot)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Time
    
    private func startTimeRegistration(forPilot pilot: Pilot) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(WorkRegistration(value: ["pilot" : pilot]))
            print("💾 \(pilot.displayName) registration start")
        }
    }

    // MARK: - Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}