//
//  LoginView.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class LoginView: UIView {
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var bottomImageConstraint: NSLayoutConstraint!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tokenField: UITextField!
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    private let bottomPadding: CGFloat = 20
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tokenField.alpha = 0
        imageView.alpha = 0
        bottomImageConstraint.constant = -tokenField.frame.size.height
    }
    
    override func resignFirstResponder() -> Bool {
        return tokenField.resignFirstResponder()
    }
    
    // MARK: - Activity
    
    func startAnimating() {
        activityView.startAnimating()
        tokenField.alpha = 0.0
    }
    
    func stopAnimating() {
        activityView.stopAnimating()
        tokenField.alpha = 1.0
    }
    
    // MARK: - Animations
    
    func animateIn() {
        UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.imageView.alpha = 1
        }) { success in
            self.bottomImageConstraint.constant = self.bottomPadding
            UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.tokenField.alpha = 1
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func handleKeyboardNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardAnimationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        self.bottomConstraint.constant = notification.name == UIKeyboardWillHideNotification ? 0.0 : keyboardBounds.size.height
        UIView.animateWithDuration(keyboardAnimationDuration) {
            self.layoutIfNeeded()
        }
    }
    
}
