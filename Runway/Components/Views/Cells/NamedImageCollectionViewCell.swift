//
//  NamedImageCollectionViewCell.swift
//  Soaringbook Runway
//
//  Created by Jelle Vandenbeeck on 06/01/15.
//  Copyright (c) 2015 Fousa. All rights reserved.
//

import UIKit

class NamedImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var textLabelTimeSpacingConstraint: NSLayoutConstraint!
    
    // MARK: Privates
    
    private let borderSize: CGFloat = 3.0
    private let selectionColor = UIColor(red:0.19, green:0.27, blue:0.34, alpha:1)
    private let color = UIColor.SBDarkGrayColor()
    
    // MARK: Overrides
    
    override var highlighted: Bool {
        didSet {
            textLabel.textColor = currentColor()
        }
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textLabel.textColor = color
        self.textLabel.backgroundColor = self.backgroundColor
        self.textLabel.opaque = true
        
        self.imageView.clipsToBounds = true
        self.imageView.backgroundColor = self.backgroundColor
        self.imageView.opaque = true
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        
        self.contentView.opaque = true
    }
    
    // MARK: - Configuration
    
    func configure(item item: WizardSelectionItem) {
        // Set text label.
        textLabel.text = item.displayName
        
        // Fill image.
        if let imageData = item.imageData {
            let image = UIImage(data: imageData)
            fillImage(image)
        } else {
            fillImage(item.image, contentMode: .Center)
        }
        
        timeLabel.hidden = true
        textLabel.textAlignment = .Center
    }
    
    func configureTime(item item: WizardSelectionItem) {
        // Set text label.
        textLabel.text = item.shortName
        
        // Fill image.
        if let imageData = item.imageData {
            let image = UIImage(data: imageData)
            fillImage(image)
        } else {
            fillImage(item.image, contentMode: .Center)
        }
        
        timeLabel.hidden = true
        textLabel.textAlignment = .Left
        textLabelTimeSpacingConstraint.priority = 800
    }
    
    func update(time time: NSDate?) {
        timeLabel.hidden = time == nil
        if let time = time {
            let difference = NSDate().timeIntervalSinceDate(time)
            timeLabel.text = difference.formatTimeDifference()
        }
    }
    
    private func fillImage(image: UIImage?, contentMode: UIViewContentMode = .ScaleAspectFill) {
        imageView.image = image ?? UIImage(named: "Empty")
        imageView.contentMode = contentMode
    }
    
    private func currentColor() -> UIColor {
        return highlighted ? selectionColor : color
    }
    
}