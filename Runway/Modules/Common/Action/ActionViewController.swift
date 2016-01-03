//
//  ActionViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 02/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

protocol ActionViewControllerDelegate: NSObjectProtocol {
    var image: UIImage? { get }
}

class ActionViewController<Controller: UIViewController where Controller: ActionViewControllerDelegate>: UIViewController {
    var actionView: ActionView! { return self.view as! ActionView }
    
    private var controller: Controller!
    
    let actionTransitioningDelegate = ActionTransitioningDelegate()
    
    // MARK: - Init
    
    convenience init(withController controller: Controller) {
        self.init(nibName: "ActionViewController", bundle: nil)
        
        self.controller = controller
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        transitioningDelegate = actionTransitioningDelegate
        modalPresentationStyle = .Custom
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        transitioningDelegate = actionTransitioningDelegate
        modalPresentationStyle = .Custom
    }
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(controller)
        actionView.contentView.addSubview(controller.view)
        controller.view.autoPinEdgesToSuperviewEdges()
        controller.didMoveToParentViewController(self)
        
        actionView.image = controller.image
    }
    
    // MARK: - First responder
    
    override func resignFirstResponder() -> Bool {
        return controller.resignFirstResponder()
    }
    
    // MARK: - Status
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
