//
//  WinterStartViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 02/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

protocol WinterStartViewControllerDelegate {
    func winterStartViewController(controller: WinterStartViewController, didStartItem item: WizardSelectionItem)
    func winterStartViewControllerDidCancel(controller: WinterStartViewController)
}

class WinterStartViewController: UIViewController, ActionViewControllerDelegate {
    
    var delegate: WinterStartViewControllerDelegate?
    var item: WizardSelectionItem!
    
    @IBOutlet var label: UILabel!
    
    // MARK: - Init
    
    convenience init(withItem item: WizardSelectionItem) {
        self.init(nibName: "WinterStartViewController", bundle: nil)
        
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
            label.text = "Ready to start working \(name)?"
        } else {
            label.text = "Ready to start working?"
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.winterStartViewControllerDidCancel(self)
    }
    
    // MARK: - Actions
    
    @IBAction func start(sender: AnyObject) {
        delegate?.winterStartViewController(self, didStartItem: item)
    }
    
    // MARK: - ActionViewControllerDelegate
    
    var image: UIImage? {
        get {
            return UIImage(named: "Watch")
        }
    }
}
