//
//  DataSource.swift
//  IOTTest
//
//  Created by Tamás Oszkó on 12/12/15.
//  Copyright © 2015 Tamás Oszkó. All rights reserved.
//

import Foundation


class ParseWrapper {
    
    static func toParse(data: Data<DHTData>) -> PFObject {
        let obj = PFObject(className: DHTMeter.ClassName)
        obj["temperature"] = data.data.temperature
        obj["humidity"] = data.data.humidity
        obj["updatedAt"] = data.modified
        return obj
    }
    
    static func fromParse(obj: PFObject) -> Data<DHTData> {
        let temperature = obj["temperature"] as! Double
        let humidity = obj["humidity"] as! Double
        return Data(data: DHTData(temperature: temperature, humidity: humidity), modified: obj.updatedAt!)
    }
    
    
}
