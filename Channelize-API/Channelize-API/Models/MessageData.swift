//
//  MessageData.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import ObjectMapper

class MessageData: CHMessageData,Mappable{
    
    var title: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    
    init() {}
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        
        title <- map["title"]
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
    
}
