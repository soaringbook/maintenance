//
//  WinterViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 14/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

// Fetch the updates from the service every 10 minutes.
private let ServiceUpdateInterval: NSTimeInterval = 60.0 * 10

private let SelectionCellSpacing: CGFloat = 10.0
private let CollectionViewSpacing: CGFloat = 20.0

class WinterViewController: UIViewController, WizardViewControllerDateSource, WizardViewControllerDelegate, WinterViewDelegate, WinterEndViewControllerDelegate {
    var winterView: WinterView! { return self.view as! WinterView }
    
    private let service: SBSyncService = SBSyncService()
    private var updatesTimer: NSTimer?
    
    private var syncablePilotsAvailable: Bool = false
    
    private var activeRegistration: Registration?
    private var activeRegistrationIndexPath: NSIndexPath?
    
    let scaleTransitionDelegate = ScaleTransitioningDelegate()
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        winterView.delegate = self
        
        updateBadge()
        reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUpdates()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.updatesTimer?.invalidate()
        self.updatesTimer = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        winterView.updateCollectionView()
    }
    
    // MARK: - Data
    
    private func reloadData() {
        winterView.registrations = Registration.registrationsInProgress()
        winterView.reloadData()
    }
    
    // MARK: - Updates
    
    private func scheduleFetchUpdates() {
        self.updatesTimer = NSTimer.scheduledTimerWithTimeInterval(ServiceUpdateInterval, target: self, selector: "fetchUpdates", userInfo: nil, repeats: false)
    }
    
    func fetchUpdates() {
        updatesTimer?.invalidate()
        service.fetchUpdates { success, updatedPilots in
            if success {
                self.syncablePilotsAvailable = updatedPilots > 0
                self.updateBadge()
            }
            dispatch_main {
                self.scheduleFetchUpdates()
            }
        }
    }
    
    private func updateBadge() {
        dispatch_main {
            let registrationsAvailable = Registration.hasUploadableRegistrations()
            let showBadge = registrationsAvailable || self.syncablePilotsAvailable
            self.winterView.toggleBadge(showBadge)
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? WizardViewController, let view = sender as? UIView where segue.identifier == "Start" {
            controller.dataSource = self
            controller.delegate = self
            
            scaleTransitionDelegate.referenceView = view
            controller.transitioningDelegate = scaleTransitionDelegate
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
    
    func winterEndViewController(controller: WinterEndViewController, didEndWithComment comment: String) {
        if let registration = activeRegistration, let indexPath = activeRegistrationIndexPath {
            print("💾 \(registration.pilot!.displayName) registration stop")
            registration.stop(withComment: comment)
            winterView.removeRegistration(atIndexPath: indexPath)
            updateBadge()
            dismissViewControllerAnimated(true, completion: nil)
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
        
        let controller = WinterEndViewController(withItem: registration.pilot!)
        controller.delegate = self
        let actionViewController = ActionViewController(withController: controller)
        presentViewController(actionViewController, animated: true, completion: nil)
    }
    
    func winterViewWillStartRegistration(view: WinterView, fromView subview: UIView) {
        performSegueWithIdentifier("Start", sender: subview)
    }
    
    func winterViewDidStartSync(view: WinterView) {
        view.startSyncing()
        service.sync { error in
            self.presentSyncCompletion()
            view.stopSyncing()
            dispatch_main_after(2.0) {
                self.fetchUpdates()
            }
        }
    }
    
    func winterViewDidCancelSync(view: WinterView) {
        service.cancel()
        view.stopSyncing()
    }
    
    // MARK: - Sync
    
    private func presentSyncCompletion() {
        dispatch_main {
            let actionViewController = ActionViewController(withController: WinterSyncFinishedViewController())
            self.presentViewController(actionViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Time
    
    private func startTimeRegistration(forPilot pilot: Pilot) {
        print("💾 \(pilot.displayName) registration start")
        Registration.start(fromPilot: pilot)
        reloadData()
    }
}