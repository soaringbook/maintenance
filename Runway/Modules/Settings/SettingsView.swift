//
//  SettingsView.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 12/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import UIKit

class SettingsView: UIView {
    @IBOutlet var activityView: UIActivityIndicatorView!
    @IBOutlet var syncButton: UIButton!
    @IBOutlet var syncLabel: UILabel!
    
    // MARK: - Activity
    
    func startAnimating() {
        syncButton.alpha = 0.0
        activityView.startAnimating()
    }
    
    func stopAnimating() {
        syncButton.alpha = 1.0
        activityView.stopAnimating()
    }
}