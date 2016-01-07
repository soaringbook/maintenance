//
//  SlideSegue.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 07/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

class SlideSegue: UIStoryboardSegue {
    override func perform() {
        let sourceView = self.sourceViewController.view as UIView!
        let destinationView = self.destinationViewController.view as UIView!
        
        // Get the screen width and height.
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        // Set the initial position of the destination view.
        destinationView.frame = CGRectMake(0.0, screenHeight, screenWidth, screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(destinationView, aboveSubview: sourceView)
        
        // Animate the transition.
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            sourceView.frame = CGRectOffset(sourceView.frame, 0.0, -screenHeight)
            destinationView.frame = CGRectOffset(destinationView.frame, 0.0, -screenHeight)
        }) { (Finished) -> Void in
            self.sourceViewController.presentViewController(self.destinationViewController as UIViewController, animated: false, completion: nil)
        }
    }
}