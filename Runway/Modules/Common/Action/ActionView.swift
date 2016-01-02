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
    @IBOutlet var roundedView: UIView!
    
    // MARK: - Setters
    
    var image: UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            return imageView.image
        }
    }
    
    // MARK: - View flow
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundedView.layer.cornerRadius = 5.0
        imageView.layer.cornerRadius = imageView.frame.size.height / 2.0
        imageView.layer.borderColor = UIColor.SBDarkGrayColor().CGColor
        imageView.layer.borderWidth = 2.0
    }
}