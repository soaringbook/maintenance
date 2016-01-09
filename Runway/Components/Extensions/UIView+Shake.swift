//
//  UIView+Shake.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 09/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

extension UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(center.x - 10, center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(center.x + 10, center.y))
        layer.addAnimation(animation, forKey: "position")
    }
}