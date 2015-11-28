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
    
    // MARK: - View flow
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
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
