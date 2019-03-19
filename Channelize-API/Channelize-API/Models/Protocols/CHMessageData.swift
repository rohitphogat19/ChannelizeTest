//
//  MessageData.swift
//  Channelize-API
//
//  Created by Apple on 1/5/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation

public protocol CHMessageData {
    
    var title: String? { get }
    var address: String? { get }
    var latitude: Double? { get }
    var longitude: Double? { get }
}
