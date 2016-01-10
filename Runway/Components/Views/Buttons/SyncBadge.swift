//
//  SyncBadge.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 10/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

class SyncBadge: UIView {
    
    // MARK: - Init
    
    init() {
        super.init(frame: CGRectZero)
        
        alpha = 0.0
        transform = CGAffineTransformMakeScale(0.5, 0.5)
        opaque = true
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        alpha = 0.0
        transform = CGAffineTransformMakeScale(0.5, 0.5)
        opaque = true
        backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Animate
    
    func show() {
        UIView.animateWithDuration(0.15) {
            self.alpha = 1.0
            self.transform = CGAffineTransformIdentity
        }
    }
    
    func hide() {
        UIView.animateWithDuration(0.15) {
            self.alpha = 0.0
            self.transform = CGAffineTransformMakeScale(0.5, 0.5)
        }
    }
    
    // MARK: - Drawing
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, UIColor.SBRedColor().CGColor)
        CGContextFillEllipseInRect(context, rect)
        
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillEllipseInRect(context, CGRectInset(rect, 6.0, 6.0))
    }
}