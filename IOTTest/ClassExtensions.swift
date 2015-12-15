//
//  DateExtensions.swift
//  IOTTest
//
//  Created by Tamás Oszkó on 12/12/15.
//  Copyright © 2015 Tamás Oszkó. All rights reserved.
//

import Foundation


extension NSDate {
    
    func localizedDiff(from: NSDate) -> String {
        let diff = abs(self.timeIntervalSinceDate(from))
        if diff < 60 {
            let sec = Int(diff)
            return "\(sec) seconds ago"
        }
        if diff < 3600 {
            let min = Int(diff / 60)
            return "\(min) minutes ago"
        }
        if diff < 3600 * 24 {
            let hour = Int(diff / 3600)
            return "\(hour) hours ago"
        }
        if diff < 3600 * 48 {
            return "yesterday"
        }
        let day = Int(diff / 3600 / 24)
        return "\(day) days ago"
    }
    
}