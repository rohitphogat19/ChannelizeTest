//
//  User.swift
//  Channelize-API
//
//  Created by Apple on 1/5/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation

public protocol CHUser{
    
    var id: String! { get }
    var displayName: String? { get }
    var language: String? { get }
    var profileImageUrl: String? { get }
    var profileUrl: String? { get }
    var isOnline: Bool? { get }
    var uVisibility: Bool? { get }
    var notification: Bool? { get }
    var isBlocked:Bool { get }
    var hasBlocked: Bool { get }
    var lastSeen: Date? { get }
    
    func setIsBlocked(status:Bool)
    func setHasBlocked(status:Bool)
    func setOnlineStatus(status:Bool?)
}
