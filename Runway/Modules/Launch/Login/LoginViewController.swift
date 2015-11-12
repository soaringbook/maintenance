//
//  LoginViewController.swift
//  Runway
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIWindow.applyBadge()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        if SBKeychain.sharedInstance.token == nil {
            loginView.animateIn()
        } else {
            dispatch_main_after(0.5) {
                self.presentDashboard()
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        loginView.reset()
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
                    self.navigationController?.presentErrorController(error)
                    self.loginView.stopAnimating()
                } else {
                    textField.resignFirstResponder()
                    self.presentDashboard()
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    private func presentDashboard() {
        performSegueWithIdentifier("Dashboard", sender: nil)
    }
    
    // MARK: - Status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Segue
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
    }
}