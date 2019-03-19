//
//  CHMember.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//
import ObjectMapper

class Member: CHMember, Mappable{
    
    var id: String!
    var userId: String?
    var chatId: String?
    var newMessageCount: Int? = 0
    var mute: Bool?
    var isTyping: Bool? = false
    var isActive: Bool?
    var isAdmin: Bool?
    var isDeleted: Bool?
    var resourceType: String?
    var lastMessageId: String?
    var updatedAt: Date?
    var user: CHUser? { return _user }
    var message: CHMessage? { return _message }
    
    internal var _user: User?
    internal var _message: Message?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        userId <- map["userId"]
        chatId <- map["chatId"]
        newMessageCount <- map["newMessageCount"]
        mute <- map["mute"]
        isActive <- map["isActive"]
        isAdmin <- map["isAdmin"]
        isDeleted <- map["isDeleted"]
        resourceType <- map["resourceType"]
        lastMessageId <- map["lastMessageId"]
        updatedAt <- (map["updatedAt"], ISODateTransform())
        _user <- map["user"]
        _message <- map["lastMessage"]
        
    }
    
    func setUser(recievedUser:CHUser) {
        let user = User()
        user.id = recievedUser.id
        user.displayName = recievedUser.displayName
        user.language = recievedUser.language
        user.profileImageUrl = recievedUser.profileImageUrl
        user.profileUrl = recievedUser.profileUrl
        user.setOnlineStatus(status: recievedUser.isOnline)
        user.uVisibility = recievedUser.uVisibility
        user.notification = recievedUser.notification
        user.setIsBlocked(status: recievedUser.isBlocked)
        user.setHasBlocked(status: recievedUser.hasBlocked)
        user.lastSeen = recievedUser.lastSeen
        self._user = user
    }
}
