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
    
    // MARK: - View flow
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.winterEndViewControllerDidCancel(self)
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? WinterEndActionViewController {
            controller.item = item
        }
    }
    
    // MARK: - ActionViewControllerDelegate
    
    var image: UIImage? {
        get {
            return UIImage(named: "Watch")
        }
    }
}
