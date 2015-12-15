//
//  DHTMeter.swift
//  IOTTest
//
//  Created by Tamás Oszkó on 12/12/15.
//  Copyright © 2015 Tamás Oszkó. All rights reserved.
//

import Foundation


class DHTMeter {
    
    static let ClassName = "DHTMeter"
    
    func update(completion:(data: [Data<DHTData>]?, last: Data<DHTData>?)->Void) -> Void {
        let query = PFQuery(className: DHTMeter.ClassName)
        query.limit = 24 * 60
        query.orderByDescending("updatedAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            guard error == nil, let objects = objects else {
                completion(data: nil, last: nil)
                return
            }
            var dhtObjs = [Data<DHTData>]()
            for obj in objects {
                let dht = ParseWrapper.fromParse(obj)
                dhtObjs.append(dht)
            }
            let dp = DataProcessor<DHTData>(data: dhtObjs)
            let todayData = dp.today({ (data: [Data<DHTData>]) -> Data<DHTData> in
                guard data.count > 0 else {
                    return Data(data: DHTData(temperature: 0, humidity: 0), modified: NSDate.distantFuture())
                }
                var avgT = 0.0
                var avgH = 0.0
                var mod = NSDate()
                var i = 0
                for d in data {
                    avgT += d.data.temperature
                    avgH += d.data.humidity
                    if i == data.count / 2 {
                        mod = d.modified
                    }
                    i++
                }
                let count = Double(data.count)
                return Data(data: DHTData(temperature: avgT/count, humidity: avgH/count), modified: mod)
                
            })
            completion(data: todayData, last: dhtObjs.first)
        }
    }
    
}

