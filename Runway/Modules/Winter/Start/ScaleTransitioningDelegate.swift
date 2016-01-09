//
//  ScaleTransitioningDelegate.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 09/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

class ScaleTransitioningDelegate: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    var shouldDismiss: Bool = false
    var referenceView: UIView!
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let sourceView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let destinationView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        let referenceFrame = referenceView.convertRect(referenceView.frame, toView: containerView!)
        
        // Calculate needed values.
        let horizontalRatio = CGRectGetWidth(referenceFrame) / CGRectGetWidth(sourceView.frame)
        let verticalRatio = CGRectGetHeight(referenceFrame) / CGRectGetHeight(sourceView.frame)
        let scaledTransform = CGAffineTransformMakeScale(horizontalRatio, verticalRatio)
        let referenceCenter = CGPointMake(CGRectGetMidX(referenceFrame), CGRectGetMidY(referenceFrame))
        
        // Initialize both views.
        if shouldDismiss {
            containerView?.insertSubview(destinationView, belowSubview: sourceView)
        } else {
            destinationView.alpha = 0.0
            destinationView.transform = scaledTransform
            destinationView.center = referenceCenter
            containerView?.addSubview(destinationView)
        }
        
        // Animate the scale and position.
        let duration = self.transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, animations: { () -> Void in
            if self.shouldDismiss {
                sourceView.alpha = 0.0
                sourceView.transform = scaledTransform
                sourceView.center =  referenceCenter
            } else {
                destinationView.alpha = 1.0
                destinationView.transform = CGAffineTransformIdentity
                destinationView.center =  sourceView.center
            }
        }) { (finished) -> Void in
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.35
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        shouldDismiss = false
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        shouldDismiss = true
        return self
    }
}