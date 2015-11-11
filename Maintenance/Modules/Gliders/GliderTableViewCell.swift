//
//  GliderTableViewCell.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 02/10/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class GliderTableViewCell : UITableViewCell {
    
    @IBOutlet var taskCountLabel: UILabel!
    
    // MARK: - Configure
    
    func configure(glider glider: Glider) {
        taskCountLabel.text = "13"
    }
    
    // MARK: - Drawing
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.SBLightGrayColor().CGColor)
        
        let padding: CGFloat = 0.5
        CGContextFillRect(context, CGRectMake(0.0, rect.size.height - padding, rect.size.width, padding))
    }
    
}