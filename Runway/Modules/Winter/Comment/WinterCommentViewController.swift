//
//  WinterCommentViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 28/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

protocol WinterCommentViewControllerDelegate {
    func winterCommentViewController(controller: WinterCommentViewController, didAddComment comment: String)
}

class WinterCommentViewController: UIViewController {
    var delegate: WinterCommentViewControllerDelegate?
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var stopButton: UIButton!
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            if let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                self.bottomConstraint.constant = value.CGRectValue().size.height - 130
                if let value = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
                    UIView.animateWithDuration(value.doubleValue) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { notification in
            self.bottomConstraint.constant = 0
            if let value = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
                UIView.animateWithDuration(value.doubleValue) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        textView.resignFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func stopRegistration(sender: AnyObject) {
        if textView.text.isEmpty {
            
        } else {
            delegate?.winterCommentViewController(self, didAddComment: textView.text)
            performSegueWithIdentifier("Dismiss", sender: nil)
        }
    }
}
