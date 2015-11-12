//
//  DashboardViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 11/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class DashboardViewController : UIViewController {
    var dashboardView: DashboardView! { return self.view as! DashboardView }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dashboardView.animateIn()
    }
    
    // MARK: - Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Segue
    
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) {
        // SHITTY iOS code in order to get unwinding work.
    }
    
//    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
//        let segue = SBSlideSegue(identifier: "Pop", source: fromViewController, destination: toViewController)
//        segue.shouldDismiss = true
//        return segue
//    }
    
//    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
    
//    }
//    
//    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
//        
//    }
}