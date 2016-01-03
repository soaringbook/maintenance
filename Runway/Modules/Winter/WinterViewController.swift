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

class WinterViewController: UIViewController, WizardViewControllerDateSource, WizardViewControllerDelegate, WinterViewDelegate, WinterEndViewControllerDelegate {
    var winterView: WinterView! { return self.view as! WinterView }
    
    private var activeRegistration: Registration?
    private var activeRegistrationIndexPath: NSIndexPath?
    
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
    
    // MARK: - Actions
    
    @IBAction func sync(sender: AnyObject) {
        let service = SBSyncService()
        service.sync { error in
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? WizardViewController where segue.identifier == "Start" {
            controller.dataSource = self
            controller.delegate = self
        }
    }
    
    @IBAction func unwindToWinter(segue: UIStoryboardSegue) {
        // Cleanup the active registration when comming back to this controller.
        activeRegistration = nil
        activeRegistrationIndexPath = nil
    }
    
    // MARK: - WizardViewControllerDateSource
    
    func controllersForWizard(controller: WizardViewController) -> [WizardChildViewController] {
        return [
            WinterPilotSelectionChildViewController(wizardViewController: controller)
        ]
    }
    
    // MARK: - WinterEndViewControllerDelegate
    
    func winterEndViewController(controller: WinterEndViewController, didEndItem item: WizardSelectionItem, withComment comment: String) {
        if let registration = activeRegistration, let indexPath = activeRegistrationIndexPath {
            print("💾 \(registration.pilot!.displayName) registration stop")
            registration.stop(withComment: comment)
            winterView.removeRegistration(atIndexPath: indexPath)
        }
    }
    
    func winterEndViewControllerDidCancel(controller: WinterEndViewController) {
        
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
        activeRegistration = registration
        activeRegistrationIndexPath = indexPath
        
        let controller = UIStoryboard(name: "WinterEnd", bundle: nil).instantiateInitialViewController() as! WinterEndViewController
        controller.item = registration.pilot
        controller.delegate = self
        let actionViewController = ActionViewController(withController: controller)
        presentViewController(actionViewController, animated: true, completion: nil)
    }
    
    func winterViewWillStartRegistration(view: WinterView) {
        performSegueWithIdentifier("Start", sender: nil)
    }
    
    // MARK: - Time
    
    private func startTimeRegistration(forPilot pilot: Pilot) {
        print("💾 \(pilot.displayName) registration start")
        Registration.start(fromPilot: pilot)
        reloadData()
    }
}