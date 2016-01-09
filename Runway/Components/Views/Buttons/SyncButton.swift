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
    
    // MARK: - Rotation
    
    func startAnimating() {
        animating = true
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 1.0
        rotateAnimation.delegate = self
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
    
    func stopAnimating() {
        animating = false
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if animating {
            startAnimating()
        }
    }
}