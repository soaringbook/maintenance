//
//  IconCollectionViewCell.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 26/12/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!
    
    // MARK: - Configuration
    
    func configure() {
        label.text = NSLocalizedString("work_buttons_add", comment: "").uppercaseString
    }
}
