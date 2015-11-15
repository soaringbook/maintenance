//
//  WizardView.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 14/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit
import PureLayout

class WizardView: UIView {
    
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dismissButton: UIButton!
    @IBOutlet private var containerView: UIView!
    
    @IBOutlet private var leftBackButtonConstraint: NSLayoutConstraint!
    @IBOutlet private var topProgressViewConstraint: NSLayoutConstraint!
    
    // MARK: - Setters
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    // MARK: - Progress
    
    func updateProgressView(currentIndex index: Int, total: Int) {
        // Hide the progressView when total = 1
        progressView.hidden = total <= 1
        
        // We add 1 to both properties in order to get an initial progress.
        let total = Float(total) + 1.0
        let current = Float(index) + 1.0
        progressView.setProgress(current / total, animated: true)
    }
    
    func positionProgressView(hidden: Bool, animated: Bool) {
        topProgressViewConstraint.constant = hidden ? -2.0 : 0.0
        if animated {
            UIView.animateWithDuration(0.15, animations: { () -> Void in
                self.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Back button
    
    func positionBackButton(currentIndex index: Int) {
        let hideBackButton = index == 0
        leftBackButtonConstraint.constant =  hideBackButton ? -CGRectGetWidth(backButton.frame) : 20.0
    }
    
    // MARK: - Child container view
    
    func addControllerView(view view: UIView) -> NSLayoutConstraint {
        containerView.addSubview(view)
        
        view.autoMatchDimension(.Height, toDimension: .Height, ofView: containerView)
        view.autoMatchDimension(.Width, toDimension: .Width, ofView: containerView)
        view.autoPinEdge(.Top, toEdge: .Top, ofView: containerView)
        
        // Return the left contstraint.
        return view.autoPinEdge(.Left, toEdge: .Left, ofView: containerView)
    }
    
    func positionOffscreen(leftConstraint constraint: NSLayoutConstraint, navigateForward: Bool = false) {
        constraint.constant = CGRectGetWidth(containerView.frame) * CGFloat(navigateForward ? 1.0 : -1.0)
    }

}
