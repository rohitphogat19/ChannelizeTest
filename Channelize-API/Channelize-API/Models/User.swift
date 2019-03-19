//
//  Customer.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import ObjectMapper

class User: CHUser, Mappable{

    var id: String!
    var displayName: String?
    var language: String?
    var profileImageUrl: String?
    var profileUrl: String?
    var isOnline: Bool? { return _isOnline}
    var uVisibility: Bool?
    var notification: Bool?
    var isBlocked:Bool { return _isBlocked }
    var hasBlocked: Bool { return _hasBlocked }
    var lastSeen: Date?
    
    fileprivate var _hasBlocked : Bool = false
    fileprivate var _isBlocked : Bool = false
    fileprivate var _isOnline : Bool = false
    init() {}
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        displayName <- map["displayName"]
        language <- map["language"]
        profileImageUrl <- map["profileImageUrl"]
        profileUrl <- map["profileUrl"]
        _isOnline <- map["isOnline"]
        uVisibility <- map["visibility"]
        notification <- map["notification"]
        _isBlocked <- map["isBlocked"]
        _hasBlocked <- map["hasBlocked"]
        lastSeen <- (map["lastSeen"], ISODateTransform())
        
    }
}

extension User {
    func setIsBlocked(status:Bool){
        self._isBlocked = status
    }
    func setHasBlocked(status:Bool){
        self._hasBlocked = status
    }
    func setOnlineStatus(status:Bool?) {
        guard status != nil else { return }
        self._isOnline = status!
    }

}

enum UserKey :String{
    case ID = "CHUserId"
    case AccessToken = "CHMainAccessKey"
    case Name = "CHUserName"
    case Visibility = "CHUserVisibility"
    case Language = "CHUserLanguage"
    case Image = "CHUserImageUrl"
    case Notification = "CHUserNotification"
    case Online = "CHUserOnline"
    
    
    func key() ->String { return self.rawValue }
}
