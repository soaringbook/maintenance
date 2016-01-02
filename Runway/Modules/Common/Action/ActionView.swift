//
//  ActionView.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 02/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

class ActionView: UIView {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var contentView: UIView!
    
    // MARK: - View flow
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.backgroundColor = UIColor.redColor()
        imageView.layer.cornerRadius = imageView.frame.size.height / 2.0
    }
}