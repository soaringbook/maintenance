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
        
        imageView.layer.cornerRadius = imageView.frame.size.height / 2.0
    }
}