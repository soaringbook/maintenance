//
//  UIAlertController+Errors.swift
//  Runway
//
//  Created by Jelle Vandenbeeck on 29/09/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(error: NSError) {
        self.init(title: NSLocalizedString("common_errors_global", comment: ""), message: error.localizedDescription, preferredStyle: .Alert)
    }
}

extension UIViewController {
    func presentErrorController(error: NSError) {
        let controller = UIAlertController(error: error)
        controller.addAction(UIAlertAction(title: NSLocalizedString("common_labels_ok", comment: ""), style: .Default, handler: nil))
        self.presentViewController(controller, animated: true, completion: nil)
    }
}