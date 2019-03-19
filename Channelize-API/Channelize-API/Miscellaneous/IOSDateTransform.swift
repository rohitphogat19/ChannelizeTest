//
//  IOSDateTransform.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import Foundation
import ObjectMapper

open class ISODateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let strValue = value as? String else { return nil }
        return formatter.date(from: strValue)
    }
    
    public func transformToJSON(_ value: Date?) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard value != nil else { return nil }
        return formatter.string(from: value!)
    }
    
}
