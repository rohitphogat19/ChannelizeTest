//
//  ChatService.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//
import Alamofire

public typealias ChatData = (_ chat: CHConversation?, _ error: Error?) -> ()
public typealias ChatsData = (_ chats: [CHConversation], _ error: Error?) -> ()


protocol ChatService: class {
    //GET
    func getRecentChatCount(completion: @escaping CountResponse)
    func getChat(chatId: String, completion: @escaping ChatData)
    func getChats(skip:Int,limit:Int, completion: @escaping ChatsData)
    func getGroupsCount(completion: @escaping (_ count: Int,_ error:Error?) -> ())
    func getGroups(skip:Int,limit:Int?,completion: @escaping ChatsData)
    func getEnabledModules(completion: @escaping ModuleData)
    //POST
    func createGroup(params:Parameters, completion: @escaping ChatData)
    func changeTitle(chatId:String,params:Parameters, completion: @escaping  ChatData)
    func updateProfile(chatId:String, data:Data, completion: @escaping ChatData)
    func addMembers(chatId: String,params: Parameters?, completion: @escaping ChatData)
    func removeChatMembers(chatId:String, params:Parameters,
                           completion: @escaping StatusResponse)
    func leaveChat(chatId:String, completion: @escaping StatusResponse)
    
    //PUT
    func addGroupAdmin(chatId:String, params:Parameters,
                       completion: @escaping StatusResponse)
    //DELETE
    func clearChat(chatId:String, completion: @escaping StatusResponse)
    func deleteChat(chatId:String, completion: @escaping StatusResponse)
    
}
