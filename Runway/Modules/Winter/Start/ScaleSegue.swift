//
//  ScaleSegue.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 07/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

class ScaleSegue: UIStoryboardSegue {
    var shouldDismiss: Bool = false
    var referenceView: UIView!
    
    override func perform() {
        let sourceView = self.sourceViewController.view as UIView!
        let destinationView = self.destinationViewController.view as UIView!
        
        let window = UIApplication.sharedApplication().keyWindow
        let referenceFrame = referenceView.convertRect(referenceView.frame, toView: window)
        
        // Calculate needed values.
        let horizontalRatio = CGRectGetWidth(referenceFrame) / CGRectGetWidth(sourceView.frame)
        let verticalRatio = CGRectGetHeight(referenceFrame) / CGRectGetHeight(sourceView.frame)
        let scaledTransform = CGAffineTransformMakeScale(horizontalRatio, verticalRatio)
        let referenceCenter = CGPointMake(CGRectGetMidX(referenceFrame), CGRectGetMidY(referenceFrame))
        
        // Initialize both views.
        if shouldDismiss {
            window?.insertSubview(destinationView, belowSubview: sourceView)
        } else {
            destinationViewController.view.alpha = 0.0
            destinationViewController.view.transform = scaledTransform
            destinationViewController.view.center = referenceCenter
            window?.addSubview(destinationView)
        }
        
        // Animate the alpha value.
        UIView.animateWithDuration(0.10, delay: self.shouldDismiss ? 0.2 : 0.0, options: .AllowAnimatedContent, animations: { () -> Void in
            if self.shouldDismiss {
                sourceView.alpha = 0.0
            } else {
                destinationView.alpha = 1.0
            }
            }, completion: nil)
        
        // Animate the scale and position.
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            if self.shouldDismiss {
                sourceView.transform = scaledTransform
                sourceView.center =  referenceCenter
            } else {
                destinationView.transform = CGAffineTransformIdentity
                destinationView.center =  sourceView.center
            }
        }) { (finished) -> Void in
            if self.shouldDismiss {
                (self.sourceViewController as UIViewController).dismissViewControllerAnimated(false, completion: nil)
            } else {
                (self.sourceViewController as UIViewController).presentViewController(self.destinationViewController as UIViewController, animated: false, completion: nil)
            }
        }
    }
}