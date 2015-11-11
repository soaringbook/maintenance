//
//  DashboardView.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 11/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class DashboardView: UIView {
    
    @IBOutlet var flightsHeightConstraint: NSLayoutConstraint!
    @IBOutlet var flightsWidthConstraint: NSLayoutConstraint!
    @IBOutlet var winterHeightConstraint: NSLayoutConstraint!
    @IBOutlet var winterWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Animations
    
    func animateIn() {
        flightsHeightConstraint.constant = 240
        flightsWidthConstraint.constant = 240
        UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
        winterHeightConstraint.constant = 240
        winterWidthConstraint.constant = 240
        UIView.animateWithDuration(0.35, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }

}
