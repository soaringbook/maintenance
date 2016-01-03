//
//  WinterEndCommentViewController.swift
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

class WinterEndViewController: UIViewController {


}
