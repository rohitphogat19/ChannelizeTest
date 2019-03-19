//
//  UserService.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//
import Alamofire

public typealias UserData = (_ user: CHUser?, _ error: Error?) -> ()
public typealias UsersData = (_ users: [CHUser], _ error: Error?) -> ()
public typealias CountResponse = (_ count: Int, _ error: Error?) -> ()
public typealias StatusResponse = (_ status: Bool, _ error: Error?) -> ()

protocol UserService: class {
    
    func getUserCount(completion: @escaping CountResponse)
    func getUser(id: String, completion: @escaping UserData)
    func getContacts(route: ApiRoute, params: Parameters?,
                     completion: @escaping UsersData)
    func getBlockedUsers(completion: @escaping UsersData)
    func getUnreadMessageCount(completion: @escaping CountResponse)
    
    //POST
    func blockUser(userId: String, completion: @escaping StatusResponse)
    func unblockUser(userId: String, completion: @escaping StatusResponse)

    
    //PUT
    func updateUserSettings(params: Parameters?,completion: @escaping UserData)
    //DELETE
    func removeMembers(chatId: String,params: Parameters?, completion: @escaping ChatData)
    
}
