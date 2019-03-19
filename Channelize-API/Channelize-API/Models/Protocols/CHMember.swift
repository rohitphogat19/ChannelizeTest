//
//  Member.swift
//  Channelize-API
//
//  Created by Apple on 1/5/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation

public protocol CHMember{
    
    var id: String! { get }
    var userId: String? { get }
    var chatId: String? { get }
    var newMessageCount: Int?{ get }
    var mute: Bool? { get }
    var isTyping: Bool? { get }
    var isActive: Bool? { get }
    var isAdmin: Bool? { get }
    var isDeleted: Bool? { get }
    var resourceType: String? { get }
    var lastMessageId: String? { get }
    var updatedAt: Date? { get }
    var user: CHUser? { get }
    var message: CHMessage? { get }
    
    func setUser(recievedUser:CHUser)
    
}

