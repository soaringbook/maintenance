//
//  LoginViewController.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func loginViewControllerWillDismiss(controller: LoginViewController)
}

class LoginViewController : UIViewController, UITextFieldDelegate {
    var loginView: LoginView! { return self.view as! LoginView }
    var delegate: LoginViewControllerDelegate?
    
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
        loginView.startAnimating()
        SBWebService().authenticate(token: textField.text ?? "") { response in
            dispatch_main {
                if let error = response.error {
                    self.presentErrorController(error)
                    self.loginView.stopAnimating()
                } else {
                    textField.resignFirstResponder()
                    self.delegate?.loginViewControllerWillDismiss(self)
                }
            }
        }
    }
}