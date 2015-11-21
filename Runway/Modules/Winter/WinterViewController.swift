//
//  WinterViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 14/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

private let SelectionCellSpacing: CGFloat = 10.0
private let CollectionViewSpacing: CGFloat = 20.0

class WinterViewController: UIViewController, WizardViewControllerDateSource, WizardViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    private var registrationItems: [Registration] = [Registration]()
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(UINib(nibName: "NamedImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(0.0, 30.0, 30.0, 30.0)
        }
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        registrationItems = Registration.registrationsInProgress()
        collectionView.reloadData()
    }
    
    // MARK: - Timer
    
    func updateTimer() {        
        for cell in collectionView.visibleCells() as! [NamedImageCollectionViewCell] {
            if let indexPath = collectionView.indexPathForCell(cell) {
                let registrationItem = registrationItems[indexPath.item]
                cell.update(time: registrationItem.startedAt)
            }
        }
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
        let alertController = UIAlertController(title: "Actions", message: "Do you want to stop working?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Stop", style: .Cancel) { action in
            let registration = self.registrationItems[indexPath.row]
            registration.stop()
            self.registrationItems.removeAtIndex(indexPath.row)
            self.collectionView.deleteItemsAtIndexPaths([indexPath])
        })
        alertController.addAction(UIAlertAction(title: "Continue", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return registrationItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! NamedImageCollectionViewCell
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
        print("💾 \(pilot.displayName) registration start")
        Registration.start(fromPilot: pilot)
    }

    // MARK: - Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}