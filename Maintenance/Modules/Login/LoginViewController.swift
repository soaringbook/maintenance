//
//  LoginViewController.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController, UITextFieldDelegate {
    var loginView: LoginView! { return self.view as! LoginView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            self.loginView.handleKeyboardNotification(notification)
        }
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            self.loginView.handleKeyboardNotification(notification)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        loginView.animateIn()
    }
    
    // MARK: - Gestures
    
    @IBAction func tap(sender: AnyObject) {
        loginView.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        authenticate(textField: textField)
        return true
    }
    
    // MARK: - Service
    
    private func authenticate(textField textField: UITextField) {
        SBWebService().authenticate(token: textField.text ?? "") { error in
            dispatch_main {
                if let error = error {
                    self.presentErrorController(error)
                } else {
                    textField.resignFirstResponder()
                    self.presentGliderFlow()
                }
            }
        }
    }
    
    private func presentGliderFlow() {
        print("presentedViewController \(presentedViewController)")
        print("presentingViewController \(presentingViewController)")
    }
}