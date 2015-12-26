//
//  ApplicationContainerViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 26/12/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class ApplicationContainerViewController: UIViewController {
    
    private var activeController: UIViewController?
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Winter", bundle: nil)
        switchTo(viewController: storyboard.instantiateInitialViewController()!)
    }
    
    // MARK: - Child controller
    
    private func switchTo(viewController controller: UIViewController) {
        if let activeController = activeController {
            hide(viewController: activeController)
        }
        show(viewController: controller)
    }
    
    private func show(viewController controller: UIViewController) {
        activeController = controller
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.view.autoPinEdgesToSuperviewEdges()
        controller.didMoveToParentViewController(self)
    }
    
    private func hide(viewController controller: UIViewController) {
        controller.willMoveToParentViewController(nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    
    // MARK: - Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}