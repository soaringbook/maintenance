//
//  ActionPresentationController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 02/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

class ActionPresentationController: UIPresentationController {
    
    // MARK: - Presentation
    
    override func presentationTransitionWillBegin() {
        containerView!.addSubview(presentedViewController.view)
        
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
        }, completion:nil)
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        let size = presentedViewController.view.intrinsicContentSize()
        return CGRectMake(0, 0, size.width, size.height)
    }
    
//    override func dismissalTransitionWillBegin()  {
//        // Fade out the overlay view alongside the transition
//        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
//        transitionCoordinator?.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
//        }, completion:nil)
//    }
    
    // MARK: - Content container protocol
    
//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator transitionCoordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransitionToSize(size, withTransitionCoordinator: transitionCoordinator)
//        
//        transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
//        }, completion:nil)
//    }
}