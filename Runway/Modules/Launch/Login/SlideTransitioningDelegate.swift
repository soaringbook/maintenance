//
//  SlideTransitionDelegate.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 09/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

class SlideTransitioningDelegate: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let sourceView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let destinationView = transitionContext.viewForKey(UITransitionContextToViewKey)!

        // Get the screen width and height.
        let screenWidth = containerView!.bounds.size.width
        let screenHeight = containerView!.bounds.size.height

        // Set the initial position of the destination view.
        destinationView.frame = CGRectMake(0.0, screenHeight, screenWidth, screenHeight)

        // Access the app's key window and insert the destination view above the current (source) one.
        containerView?.addSubview(destinationView)
        
        // Animate the transition.
        let duration = self.transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, animations: { () -> Void in
            sourceView.frame = CGRectOffset(sourceView.frame, 0.0, -screenHeight)
            destinationView.frame = CGRectOffset(destinationView.frame, 0.0, -screenHeight)
        }) { (Finished) -> Void in
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}