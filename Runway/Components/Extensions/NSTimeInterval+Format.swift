//
//  NSTimeInterval+Format.swift
//  Runway
//
//  Created by Jelle Vandebeeck on 21/11/15.
//  Copyright © 2015 Soaring Book. All rights reserved.
//

import Foundation

extension NSTimeInterval {
    func formatTimeDifference() -> String {
        let seconds = Int(self % 60.0)
        let minutes = Int((self / 60.0) % 60.0)
        let hours = Int(self / 3600.0)
        return NSString(format:"%02i:%02i:%02i", hours, minutes, seconds) as String
    }
}