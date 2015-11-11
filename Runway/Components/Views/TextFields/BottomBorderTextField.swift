//
//  BottomBorderTextField.swift
//  Runway
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

@IBDesignable class BottomBorderedTextField: UITextField {
    
    @IBInspectable var borderColor: UIColor = UIColor.redColor() {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Drawing
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        // Draw bottom border.
        CGContextSetFillColorWithColor(context, borderColor.CGColor)
        CGContextFillRect(context, CGRectMake(0, rect.size.height - 2.0, rect.size.width, 2.0))
    }
}
