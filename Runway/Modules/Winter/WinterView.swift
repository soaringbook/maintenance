//
//  WinterView.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 21/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

protocol WinterViewDelegate {
    func winterView(view: WinterView, didSelectRegistration registration: Registration, atIndexPath indexPath: NSIndexPath)
}

class WinterView: UIView {
    @IBOutlet var collectionView: UICollectionView!
    
    var delegate: WinterViewDelegate?
    
    var registrations: [Registration] = [Registration]()
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.registerNib(UINib(nibName: "NamedImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(0.0, 30.0, 30.0, 30.0)
        }
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
    }
    
    // MARK: - Data
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func removeRegistration(atIndexPath indexPath: NSIndexPath) {
        registrations.removeAtIndex(indexPath.row)
        collectionView.deleteItemsAtIndexPaths([indexPath])
    }
    
    // MARK: - Timer
    
    func updateTimer() {
        for cell in collectionView.visibleCells() as! [NamedImageCollectionViewCell] {
            if let indexPath = collectionView.indexPathForCell(cell) {
                let registration = registrations[indexPath.item]
                cell.update(time: registration.startedAt)
            }
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let registration = registrations[indexPath.row]
        delegate?.winterView(self, didSelectRegistration: registration, atIndexPath: indexPath)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return registrations.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! NamedImageCollectionViewCell
        let item = registrations[indexPath.item]
        cell.configure(item: item.pilot!)
        return cell
    }
}