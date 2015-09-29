//
//  GlidersViewController.swift
//  Maintenance
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class GlidersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    private var gliders = [NSDictionary]()
    
    // MARK: - View flow
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func reload(sender: AnyObject) {
        SBWebService().fetchGliders { (error, data) -> () in
            if let gliderList = data?["gliders"] as? [NSDictionary] {
                self.gliders = gliderList
                dispatch_main {
                    self.collectionView.reloadData()
                }
                
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gliders.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GliderCell", forIndexPath: indexPath)
        return cell
    }
}
