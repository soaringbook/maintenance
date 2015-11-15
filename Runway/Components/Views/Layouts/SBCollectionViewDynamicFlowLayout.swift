//
//  SBCollectionViewDynamicFlowLayout.swift
//  Soaringbook Runway
//
//  Created by Jelle Vandenbeeck on 08/01/15.
//  Copyright (c) 2015 Fousa. All rights reserved.
//

import UIKit

class SBCollectionViewDynamicFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Privates
    
    private var dynamicAnimator: UIDynamicAnimator!
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    // MARK: - Reset
    
    func resetLayout() {
        dynamicAnimator?.removeAllBehaviors()
        prepareLayout()
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    override func prepareLayout() {
        super.prepareLayout()
        
        let contentSize = self.collectionViewContentSize() ?? CGSizeZero
        let items = super.layoutAttributesForElementsInRect(CGRectMake(0.0, 0.0, contentSize.width, contentSize.height))! as [UIDynamicItem]
        
        if dynamicAnimator!.behaviors.count == 0 {
            for item in items as [UIDynamicItem] {
                let behavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
                behavior.length = 0.0
                behavior.damping = 0.9
                behavior.frequency = 1.0
                dynamicAnimator!.addBehavior(behavior)
            }
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        return dynamicAnimator.itemsInRect(rect) as! [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return dynamicAnimator?.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let delta = newBounds.origin.x - collectionView!.bounds.origin.x
        let touchLocation = collectionView!.panGestureRecognizer.locationInView(collectionView!)
        
        for behavior in dynamicAnimator!.behaviors as! [UIAttachmentBehavior] {
            let yDistanceFromTouch = CGFloat(fabsf(Float(touchLocation.y - behavior.anchorPoint.y)))
            let xDistanceFromTouch = CGFloat(fabsf(Float(touchLocation.x - behavior.anchorPoint.x)))
            let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / CGFloat(1500.0)
            
            let item = behavior.items.first as! UICollectionViewLayoutAttributes
            var center = item.center ?? CGPointZero
            if delta < 0 {
                center.x += CGFloat(max(delta, delta * scrollResistance))
            } else {
                center.x += CGFloat(min(delta, delta * scrollResistance))
            }
            item.center = center
            
            dynamicAnimator!.updateItemUsingCurrentState(item)
        }
        
        return false
    }

}