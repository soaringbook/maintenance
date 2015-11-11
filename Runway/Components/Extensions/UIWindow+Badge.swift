//
//  WRBadgeWindow.swift
//  Soaringbook Runway
//
//  Created by Jelle Vandenbeeck on 30/12/14.
//  Copyright (c) 2014 Fousa. All rights reserved.
//

import UIKit
import AGWindowView
import PureLayout

extension UIWindow {
    class func applyBadge() {
        let imageName = NSBundle.mainBundle().objectForInfoDictionaryKey("BADGE_IMAGE_NAME") as! String
        if let image = UIImage(named: imageName) {
            self.applyBadge(image: image)
        }
    }

    private class func applyBadge(image image: UIImage) {
        let badgeContainerView = AGWindowView(andAddToWindow: UIApplication.sharedApplication().keyWindow)
        badgeContainerView.userInteractionEnabled = false
        
        let badge = UIImageView(image: image)
        badgeContainerView.addSubview(badge)
        badge.autoSetDimensionsToSize(image.size)
        badge.autoPinEdgeToSuperviewEdge(.Bottom)
        badge.autoPinEdgeToSuperviewEdge(.Left)
    }
}