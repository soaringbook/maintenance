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
    @IBOutlet var button: UIButton!
    
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

        button.setTitle(NSLocalizedString("work_buttons_start_working", comment: ""), forState: .Normal)
        if let name = item.shortName {
            let localizedLabel = NSLocalizedString("work_labels_start_ready_user", comment: "")
            label.text = String(NSString(format: localizedLabel, name))
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
