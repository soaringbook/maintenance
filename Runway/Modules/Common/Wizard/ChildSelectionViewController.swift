//
//  WizardChildSelectionViewController.swift
//  Soaringbook Runway
//
//  Created by Jelle Vandenbeeck on 06/01/15.
//  Copyright (c) 2015 Fousa. All rights reserved.
//

import UIKit

enum ChildSelectionMessage {
    case None
    case Warning(NSString)
    case Error(NSString)
    
    init(errorMessage: NSString?, warningMessage: NSString?) {
        if let errorMessage = errorMessage {
            self = .Error(errorMessage)
        } else if let warningMessage = warningMessage {
            self = .Warning(warningMessage)
        } else {
            self = .None
        }
    }
    
    func message() -> NSString? {
        switch (self) {
        case .Warning(let warningMessage): return warningMessage
        case .Error(let errorMessage): return errorMessage
        default: return nil
        }
    }
    
    func messageColor() -> UIColor? {
        switch (self) {
        case .Warning: return UIColor(red:0.96, green:0.67, blue:0.38, alpha:0.8)
        case .Error: return UIColor(red:0.92, green:0.34, blue:0.41, alpha:0.8)
        default: return nil
        }
    }
}

struct ChildSelectionItem {
    var rawImageData: NSData?
    var image: UIImage?
    var label: NSString?
    var message: ChildSelectionMessage
}

class ChildSelectionViewController: WizardChildViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // MARK: - Public
    
    var list = [Pilot]()
    
    // MARK: Privates
    
    private let collectionViewHeight: CGFloat = 220.0
    private var collectionView: UICollectionView?
    private var searchField: UITextField?
    private var itemSize: CGFloat?
    
    // MARK: Getters
    
    override var wizardTitle: String {
        assertionFailure("Should be overwritten set by subclass.")
        return ""
    }
    
    var searchPlaceholderTitle: String {
        assertionFailure("Should be overwritten set by subclass.")
        return ""
    }
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSearchField()
        prepareCollectionView()
        prepareLogo()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareContent()
        
        dispatch_main_after(0.4) {
            self.searchField?.becomeFirstResponder()
            return
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchField?.resignFirstResponder()
    }
    
    // MARK: - Data
    
    private func prepareContent(query: NSString? = nil) {
        list = constructList(query)
        self.collectionView?.reloadData()
//        (self.collectionView?.collectionViewLayout as! RWCollectionViewDynamicFlowLayout).resetLayout()
        self.collectionView?.scrollRectToVisible(CGRectMake(0, 0, 10, 10), animated: false)
    }
    
    // MARK: - Label
    
    private func prepareLogo() {
        // Configure quote label.
        let logoImageView = UIImageView(image: UIImage(named: "Quote"))
        logoImageView.contentMode = .Center
        view.addSubview(logoImageView)
        logoImageView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0), excludingEdge: .Top)
        logoImageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: collectionView!)
    }
    
    // MARK: - Search
    
    private func prepareSearchField() {
        // Configure search field.
        searchField = UITextField()
        searchField?.placeholder = searchPlaceholderTitle as String
        searchField!.autocorrectionType = .No
        searchField!.autocapitalizationType = .AllCharacters
        searchField?.delegate = self
        searchField?.backgroundColor = view.backgroundColor
        searchField?.opaque = true
        view.addSubview(searchField!)
        
        searchField!.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0), excludingEdge: .Bottom)
        searchField!.autoSetDimension(.Height, toSize: 50.0)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let query: NSString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        prepareContent(query)
        return true
    }
    
    // MARK: - Collection view
    
    private func prepareCollectionView() {
        // Configure layout.
        let layout = UICollectionViewLayout()
//        let layout = RWCollectionViewDynamicFlowLayout()
//        layout.scrollDirection = .Horizontal
//        layout.sectionInset = UIEdgeInsets(top: CollectionViewSpacing, left: CollectionViewSpacing, bottom: CollectionViewSpacing, right: CollectionViewSpacing)
//        itemSize = collectionViewHeight - CollectionViewSpacing * 2.0
//        layout.itemSize = CGSizeMake(itemSize!, itemSize!)
//        layout.minimumLineSpacing = SelectionCellSpacing
//        layout.minimumInteritemSpacing = SelectionCellSpacing
        
        // Configure collection view.
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        self.view.addSubview(collectionView!)
        collectionView!.autoPinEdge(.Top, toEdge: .Bottom, ofView: searchField!)
        collectionView!.autoPinEdgeToSuperviewEdge(.Left)
        collectionView!.autoPinEdgeToSuperviewEdge(.Right)
        collectionView!.autoSetDimension(.Height, toSize: collectionViewHeight)
        let nib = UINib(nibName: "ImageSelectionViewCell", bundle: nil)
        collectionView!.registerNib(nib, forCellWithReuseIdentifier: "Selection")
        collectionView!.backgroundColor = UIColor.clearColor()
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.showsHorizontalScrollIndicator = false
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Selection", forIndexPath: indexPath) //as! ImageSelectionViewCell
//        let item = list[indexPath.item]
//        cell.configure(item: selectionItem(item))
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let item: NSManagedObject = list[indexPath.item] as NSManagedObject
//        let contextItem = item.MR_inContext(self.wizardViewController?.creationContext) as NSManagedObject
//        selectItem(contextItem)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(itemSize ?? 0.0, itemSize ?? 0.0)
    }
    
    // MARK: - Data
    
    func constructList(query: NSString? = nil) -> [Pilot] {
        assertionFailure("Should be overwritten set by subclass.")
        return [Pilot]()
    }
    
    func selectionItem(item: Pilot) -> ChildSelectionItem {
        assertionFailure("Should be overwritten set by subclass.")
        return ChildSelectionItem(rawImageData: nil, image: nil, label: nil, message: ChildSelectionMessage.None)
    }
    
    func selectItem(item: Pilot) {
        assertionFailure("Should be overwritten set by subclass.")
    }
    
}