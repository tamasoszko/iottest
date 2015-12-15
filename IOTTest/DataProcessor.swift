
//  DataProcessor.swift
//  IOTTest
//
//  Created by Tamás Oszkó on 13/12/15.
//  Copyright © 2015 Tamás Oszkó. All rights reserved.
//

import Foundation

class DataProcessor<T> {
    
    let data: [Data<T>]
    
    init(data: [Data<T>]) {
        self.data = data
    }
    
    func today(average: ([Data<T>]) -> Data<T>?) -> [Data<T>] {
        
        let now = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let nowComp = cal?.components((NSCalendarUnit(rawValue:NSCalendarUnit.Year.rawValue|NSCalendarUnit.Month.rawValue|NSCalendarUnit.Day.rawValue)), fromDate: now)
        
        var intervals = [[Data<T>]]()
        var result : [Data<T>] = []
        for var i = 0; i < 24 * 4; i++ {
            intervals.append([])
        }
        for d in data {
            print(d)
            let dComp = cal?.components((NSCalendarUnit(rawValue:NSCalendarUnit.Year.rawValue|NSCalendarUnit.Month.rawValue|NSCalendarUnit.Day.rawValue | NSCalendarUnit.Hour.rawValue | NSCalendarUnit.Minute.rawValue)), fromDate: d.modified)
            guard dComp?.day == nowComp?.day && dComp?.month == nowComp?.month &&
                dComp?.year == nowComp?.year else {
                    continue
            }
            let index = intervalIndex(dComp!)
            intervals[index].append(d)
        }
        var last: Data<T>?
        for interval in intervals {
            if let avg = average(interval) { // where now.timeIntervalSinceDate(avg.modified) > 0 {
                let diff = now.timeIntervalSinceDate(avg.modified)
                print("diff=\(diff)")
                if(diff > 0) {
                    result.append(avg)
                    last = avg
                } else if let last = last {
                    result.append(last)
                }
            }
        }
        
        return result
    }
    
    private func intervalIndex(datComp : NSDateComponents) -> Int {
        print("hour=\(datComp.hour), min=\(datComp.minute)")
        let index: Int = datComp.hour * 4 + datComp.minute / 15
        print("index = \(index)")
        return index
    }
    
}