//
//  ActionPresentationController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 02/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

class ActionPresentationController: UIPresentationController {
    // This will be the overlay view that is presented on top
    // of the presening controller's view
    private var overlayView: UIView?
    
    // MARK: - Presentation
    
    override func presentationTransitionWillBegin() {
        overlayView = UIView()
        overlayView?.backgroundColor = UIColor.blackColor()
        overlayView?.alpha = 0.8
        
        // Add a dismiss gesture tot the overlay view.
        let gesture = UITapGestureRecognizer(target: self, action: "dismiss:")
        overlayView?.addGestureRecognizer(gesture)

        // Add the presented view to the heirarchy
//        overlayView?.frame = containerView!.bounds
        containerView?.addSubview(presentedViewController.view)
        
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.containerView?.insertSubview(self.overlayView!, belowSubview: self.presentedViewController.view)
            self.overlayView?.autoPinEdgesToSuperviewEdges()
        }, completion:nil)
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        let size = presentedViewController.view.intrinsicContentSize()
        return CGRectMake(0, 0, size.width, size.height)
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        if !completed {
            overlayView?.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin()  {
        // Fade out the overlay view alongside the transition
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.overlayView?.removeFromSuperview()
        }, completion:nil)
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            overlayView?.removeFromSuperview()
        }
    }
    
    // MARK: - Content container protocol
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator transitionCoordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: transitionCoordinator)
        
        transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
//            self.overlayView?.frame = self.containerView!.bounds
        }, completion:nil)
    }
    
    // MARK: - Gestures
    
    func dismiss(sender: AnyObject) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}