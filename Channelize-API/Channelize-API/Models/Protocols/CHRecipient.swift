//
//  Recipient.swift
//  Channelize-API
//
//  Created by Apple on 1/5/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation

public protocol CHRecipient {
    
    var id: String! { get }
    var recipientId: String? { get }
    var status: Int? { get }
    var createdAt: Date? { get }
    
    func setStatus(status:Int)
}
