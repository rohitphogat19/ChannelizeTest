//
//  ReceivedDataDelegate.swift
//  PrimeMessenger
//
//  Created by Ashish on 03/05/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import Foundation

public protocol CHUserEventDelegate {
    
    func didUserAdded(user: CHUser?)
    func didUserRemoved(user: CHUser?)
    func didChangeUserStatus(user: CHUser?)
    func didUserBlocked(isMe:Bool,userId:String?)
    func didUserUnblocked(isMe:Bool,user: CHUser?)
    
}
public extension CHUserEventDelegate {
    func didUserAdded(user: CHUser?){}
    func didUserRemoved(user: CHUser?){}
    func didChangeUserStatus(user: CHUser?){}
    func didUserBlocked(isMe:Bool,userId:String?){}
    func didUserUnblocked(isMe:Bool,user: CHUser?){}
}


