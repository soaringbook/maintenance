//
//  SyncButton.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 09/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

class SyncButton: UIButton {
    
    private(set) var animating: Bool = false
    private(set) var badgeView: SyncBadge!
    
    // MARK: - View flow
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        badgeView = SyncBadge()
        addSubview(badgeView)
        let centerConstraints = badgeView.autoCenterInSuperview()
        for constraint in centerConstraints {
            if constraint.firstAttribute == .CenterX {
                constraint.constant = 15
            } else {
                constraint.constant = -15
            }
        }
        badgeView.autoSetDimensionsToSize(CGSizeMake(20.0, 20.0))
    }
    
    // MARK: - Badge
    
    func showBadge() {
        badgeView.show()
    }
    
    func hideBadge() {
        badgeView.hide()
    }
    
    // MARK: - Rotation
    
    func startAnimating() {
        hideBadge()
        animating = true
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 1.0
        rotateAnimation.delegate = self
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
    
    func stopAnimating() {
        userInteractionEnabled = false
        animating = false
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if animating {
            startAnimating()
        } else {
            userInteractionEnabled = true
        }
    }
}