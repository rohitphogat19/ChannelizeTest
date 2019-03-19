//
//  Tag.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import ObjectMapper

class Tag: CHTag, Mappable{
    
    var id:String!
    var userId:String?
    var order:Int?
    var wordCount:Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        userId <- map["userId"]
        order <- map["order"]
        wordCount <- map["wordCount"]
    }
    
}
