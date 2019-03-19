//
//  Module.swift
//  Channelize-API
//
//  Created by Apple on 1/5/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation

public protocol CHModule {
    
    var id:String! { get }
    var disabledBy:String? { get }
    var enabled:Int? { get }
    var identifier:String? { get }
    var name: String? { get }
    var priority:Int? { get }
}
