//
//  CHFile.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//
import ObjectMapper

class File: CHFile, Mappable{
    
    var id: String!
    var fileUrl: String?
    var name: String?
    var thumbnailUrl: String?
    var attachmentType: String?
    var duration:Double?
    
    init() {}
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        fileUrl <- map["fileUrl"]
        name <- map["name"]
        thumbnailUrl <- map["thumbnailUrl"]
        attachmentType <- map["attachmentType"]
        duration <- map["duration"]
    }
    
}
