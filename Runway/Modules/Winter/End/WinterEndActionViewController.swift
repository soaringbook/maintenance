//
//  WinterEndActionViewController.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 03/01/16.
//  Copyright © 2016 Soaring Book. All rights reserved.
//

import UIKit

class WinterEndActionViewController: UIViewController {
    
    var item: WizardSelectionItem!
    
    @IBOutlet var label: UILabel!
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = item.shortName {
            label.text = "Done working for today \(name)?"
        } else {
            label.text = "Done working for today?"
        }
    }
    
    // MARK: - Actions
    
    @IBAction func end(sender: AnyObject) {
//        if textView.text.isEmpty {
//            
//        } else {
//            delegate?.winterEndViewController(self, didEndItem: item, withComment: textView.text)
//        }
    }
}
