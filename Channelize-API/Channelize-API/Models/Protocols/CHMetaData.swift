//
//  MetaData.swift
//  Channelize-API
//
//  Created by Apple on 1/5/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation

public protocol CHMetaData {
    
    var id: String! { get }
    var subType: String? { get }
    var subId: String? { get }
    var objType: String? { get }
    var objValues: Any? { get }
    
    func msgLabel(_ chat:CHConversation?,type:String)->String?
}
