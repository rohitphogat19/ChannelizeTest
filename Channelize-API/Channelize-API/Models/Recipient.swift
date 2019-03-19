//
//  Recipient.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import ObjectMapper

open class Recipient: CHRecipient, Mappable{
    
    public var id: String!
    public var recipientId: String?
    public var status: Int? { return _status }
    public var createdAt: Date?
    
    private var _status : Int?
    init() {}
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        
        id <- map["id"]
        recipientId <- map["recipientId"]
        _status <- map["status"]
        createdAt <- (map["createdAt"], ISODateTransform())
    }

}

extension Recipient {
    public func setStatus(status:Int) {
        self._status = status
    }
}
