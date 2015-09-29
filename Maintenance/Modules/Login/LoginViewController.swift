//
//  LoginViewController.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tokenField: UITextField!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            self.handleKeyboardNotification(notification)
        }
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            self.handleKeyboardNotification(notification)
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        authenticate()
        return textField.resignFirstResponder()
    }
    
    // MARK: - Service
    
    private func authenticate() {
        SBWebService().authenticate(token: tokenField.text ?? "") { error in
            print("error \(error)")
        }
    }
    
    // MARK: - Animations
    
    private func handleKeyboardNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardAnimationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        self.bottomConstraint.constant = notification.name == UIKeyboardWillHideNotification ? 0.0 : keyboardBounds.size.height
        UIView.animateWithDuration(keyboardAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}