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
        return textField.resignFirstResponder()
    }
    
    // MARK: - Service
    
    private func authenticate(textField textField: UITextField) {
        SBWebService().authenticate(token: textField.text ?? "") { error in
            if let error = error {
                let controller = UIAlertController(error: error)
                controller.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                dispatch_main {
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            } else {
                
            }
        }
    }
}