//
//  WizardViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 14/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

protocol WizardViewControllerDelegate {
    func wizardControllerShouldDismiss(controller: WizardViewController)
    func wizardControllerWillComplete(controller: WizardViewController, fromController: WizardChildViewController)
    func wizardController(controller: WizardViewController, toController: WizardChildViewController, fromController: WizardChildViewController)
}

protocol WizardViewControllerDateSource {
    func controllersForWizard(controller: WizardViewController) -> [WizardChildViewController]
}

class WizardViewController: UIViewController {
    var wizardView: WizardView! { return self.view as! WizardView }
    
    var dataSource: WizardViewControllerDateSource?
    var delegate: WizardViewControllerDelegate?
    
    private var controllers = [WizardChildViewController]()
    private var currentIndex = 0
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Otherwise the hidden back button is shown during the animation.
        view.clipsToBounds = true
        
        // Fetch the controllers from the dataSource.
        controllers = dataSource?.controllersForWizard(self) ?? [WizardChildViewController]()
        
        // Enlarge the progress view.
        wizardView.updateProgressView(currentIndex: currentIndex, total: controllers.count)
        
        wizardView.positionBackButton(currentIndex: currentIndex)
        presentInitialController()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show the progressview after animation finished.
        wizardView.positionProgressView(false, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func back(sender: AnyObject) {
        let controller = controllers[currentIndex]
        controller.viewWillDisappear(true)
        
        presentPreviousController()
    }
    
    // MARK: - View controllers
    
    func presentNextController() {
        presentViewController(currentIndex + 1)
    }
    
    func presentPreviousController() {
        presentViewController(currentIndex - 1)
    }
    
    private func presentInitialController() {
        if currentIndex >= 0 && currentIndex < controllers.count {
            let controller = controllers[currentIndex]
            addChildViewController(controller)
            let leftConstraint = wizardView.addControllerView(view: controller.view)
            controller.didMoveToParentViewController(self)
            
            controller.leftConstraint = leftConstraint
            wizardView.titleText = controller.wizardTitle
        }
    }
    
    private func presentViewController(index: Int) {
        // Define navigation direction.
        let navigateForward = index > currentIndex
        
        // Ignore when out of bounds.
        if index < 0 || index >= controllers.count {
            if navigateForward {
                delegate?.wizardControllerWillComplete(self, fromController: controllers[currentIndex])
            }
            return
        }
        
        // Fetch the controllers.
        let oldController = controllers[currentIndex]
        let newController = controllers[index]
        
        if navigateForward {
            delegate?.wizardController(self, toController: oldController, fromController: newController)
        }
        
        // Set the new current index.
        currentIndex = index
        
        // Prepare the controllers for movement.
        oldController.willMoveToParentViewController(nil)
        addChildViewController(newController)
        
        // Add the new controller to the container view.
        let leftConstraint = wizardView.addControllerView(view: newController.view)
        wizardView.positionOffscreen(leftConstraint: leftConstraint, navigateForward: navigateForward)
        
        // Set the new title and add the left constraint to the child.
        newController.leftConstraint = leftConstraint
        wizardView.titleText = newController.wizardTitle as String
        
        // Set the initial position of the views before animating.
        view.layoutIfNeeded()
        // Animate the swipe navigation.
        leftConstraint.constant = 0
        if let leftConstraint = oldController.leftConstraint {
            wizardView.positionOffscreen(leftConstraint: leftConstraint, navigateForward: !navigateForward)
        }
        wizardView.positionBackButton(currentIndex: currentIndex)
        wizardView.updateProgressView(currentIndex: currentIndex, total: controllers.count)
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: { (finished) -> Void in
            // Remove the old view from the container.
            oldController.view.removeFromSuperview()
            oldController.removeFromParentViewController()
            newController.didMoveToParentViewController(self)
        })
    }
    
    // MARK: - Actions
    
    @IBAction func dismiss(sender: AnyObject) {
        delegate?.wizardControllerShouldDismiss(self)
    }
    
    // MARK: - Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
