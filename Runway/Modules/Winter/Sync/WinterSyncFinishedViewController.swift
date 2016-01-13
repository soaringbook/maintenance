//
//  WinterSyncFinishedViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 10/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

class WinterSyncFinishedViewController: UIViewController, ActionViewControllerDelegate {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var button: UIButton!
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = NSLocalizedString("sync_labels_finished", comment: "")
        button.setTitle(NSLocalizedString("sync_buttons_continue", comment: ""), forState: .Normal)
    }
    
    // MARK: - Actions
    
    @IBAction func dismiss(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - ActionViewControllerDelegate
    
    var image: UIImage? {
        get {
            return UIImage(named: "Watch")
        }
    }

}
