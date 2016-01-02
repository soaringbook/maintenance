//
//  SearchTextField.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 02/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

@IBDesignable class SearchTextField: UITextField {
    
    @IBInspectable var borderColor: UIColor = UIColor.SBGreenColor() {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Drawing
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
                
        // Draw bottom border.
        CGContextSetFillColorWithColor(context, borderColor.CGColor)
        CGContextFillRect(context, CGRectMake(0, rect.size.height - 2.0, rect.size.width, 2.0))
    }
}