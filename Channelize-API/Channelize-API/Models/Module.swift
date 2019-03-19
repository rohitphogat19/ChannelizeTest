//
//  Module.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import ObjectMapper

class Module: CHModule, Mappable{
    
    var id:String!
    var disabledBy:String?
    var enabled:Int?
    var identifier:String?
    var name: String?
    var priority:Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["_id"]
        disabledBy <- map["disabledBy"]
        enabled <- map["enabled"]
        identifier <- map["identifier"]
        name <- map["name"]
        priority <- map["priority"]
    }
    
}
