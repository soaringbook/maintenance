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
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(controller)
        actionView.contentView.addSubview(controller.view)
        controller.view.autoPinEdgesToSuperviewEdges()
        controller.didMoveToParentViewController(self)
        
        actionView.image = controller.image
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            if let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let bottomConstraint = self.actionView.constraints.filter { (constraint) -> Bool in
                    constraint.firstAttribute == .Bottom && constraint.secondAttribute == .Bottom
                }.first
                
                bottomConstraint?.constant = value.CGRectValue().size.height
                if let value = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
                    UIView.animateWithDuration(value.doubleValue) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            let bottomConstraint = self.actionView.constraints.filter { (constraint) -> Bool in
                return constraint.firstAttribute == .Bottom && constraint.secondAttribute == .Bottom
            }.first
            
            bottomConstraint?.constant = 0
            if let value = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
                UIView.animateWithDuration(value.doubleValue) {
                    self.view.layoutIfNeeded()
                }
            }
        }
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
