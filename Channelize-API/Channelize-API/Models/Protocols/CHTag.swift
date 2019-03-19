//
//  Tag.swift
//  Channelize-API
//
//  Created by Apple on 1/5/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation

public protocol CHTag {
    
    var id:String! { get }
    var userId:String? { get }
    var order:Int? { get }
    var wordCount:Int? { get }
}
