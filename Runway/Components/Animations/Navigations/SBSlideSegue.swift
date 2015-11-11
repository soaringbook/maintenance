//
//  SBSlideSegue.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 11/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class SBSlideSegue: UIStoryboardSegue {

    // MARK: - Public
    
    var shouldDismiss: Bool = false
    
    // MARK: - Transition
    
    override func perform() {
        let sourceViewController = self.sourceViewController as UIViewController
        let destinationViewController = self.destinationViewController as UIViewController
        
        // Initialize both views.
        let x = shouldDismiss ? -destinationViewController.view.frame.size.width : destinationViewController.view.frame.size.width
        destinationViewController.view.frame = CGRectMake(x, 0, destinationViewController.view.frame.size.width, destinationViewController.view.frame.size.height)
        sourceViewController.view.superview?.addSubview(destinationViewController.view)
        
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            destinationViewController.view.frame = CGRectMake(0, 0, destinationViewController.view.frame.size.width, destinationViewController.view.frame.size.height)
            let x = self.shouldDismiss ? destinationViewController.view.frame.size.width : -destinationViewController.view.frame.size.width
            sourceViewController.view.frame = CGRectMake(x, 0, destinationViewController.view.frame.size.width, destinationViewController.view.frame.size.height)
            }) { (finished) -> Void in
                if self.shouldDismiss {
                    sourceViewController.navigationController?.popViewControllerAnimated(false)
                } else {
                    sourceViewController.navigationController?.pushViewController(destinationViewController, animated: false)
                }
        }
    }
}
