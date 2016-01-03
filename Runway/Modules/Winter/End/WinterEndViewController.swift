//
//  WinterEndViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 03/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

protocol WinterEndViewControllerDelegate {
    func winterEndViewController(controller: WinterEndViewController, didEndItem item: WizardSelectionItem, withComment comment: String)
    func winterEndViewControllerDidCancel(controller: WinterEndViewController)
}

class WinterEndViewController: UIViewController, ActionViewControllerDelegate {
    
    var delegate: WinterEndViewControllerDelegate?
    var item: WizardSelectionItem!
    
    @IBOutlet var label: UILabel!
    @IBOutlet var textView: UITextView!
    
    // MARK: - Init
    
    convenience init(withItem item: WizardSelectionItem) {
        self.init(nibName: "WinterEndViewController", bundle: nil)
        
        self.item = item
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = item.shortName {
            label.text = "Done working for today \(name)?"
        } else {
            label.text = "Done working for today?"
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.winterEndViewControllerDidCancel(self)
    }
    
    // MARK: - Actions
    
    @IBAction func end(sender: AnyObject) {
        if textView.text.isEmpty {
            
        } else {
            delegate?.winterEndViewController(self, didEndItem: item, withComment: textView.text)
        }
    }
    
    // MARK: - ActionViewControllerDelegate
    
    var image: UIImage? {
        get {
            return UIImage(named: "Watch")
        }
    }
}
