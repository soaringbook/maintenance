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

class WinterViewController: UIViewController, WizardViewControllerDateSource, WizardViewControllerDelegate, WinterViewDelegate {
    var winterView: WinterView! { return self.view as! WinterView }
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        winterView.delegate = self
        reloadData()
    }
    
    // MARK: - Data
    
    private func reloadData() {
        winterView.registrations = Registration.registrationsInProgress()
        winterView.reloadData()
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? WizardViewController where segue.identifier == "Start" {
            controller.dataSource = self
            controller.delegate = self
        }
    }
    
    @IBAction func unwindToWinter(segue: UIStoryboardSegue) {
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
    
    // MARK: - WinterViewDelegate
    
    func winterView(view: WinterView, didSelectRegistration registration: Registration, atIndexPath indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: "Actions", message: "Do you want to stop working?", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Stop", style: .Cancel) { action in
            self.performSegueWithIdentifier("Comment", sender: nil)
//            self.stopTimeRegistration(forRegistration: registration, atIndexPath: indexPath)
        })
        alertController.addAction(UIAlertAction(title: "Continue", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Time
    
    private func startTimeRegistration(forPilot pilot: Pilot) {
        print("💾 \(pilot.displayName) registration start")
        Registration.start(fromPilot: pilot)
        reloadData()
    }
    
    private func stopTimeRegistration(forRegistration registration: Registration, atIndexPath indexPath: NSIndexPath) {
        print("💾 \(registration.pilot!.displayName) registration stop")
        registration.stop()
        winterView.removeRegistration(atIndexPath: indexPath)
    }

    // MARK: - Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}