//
//  CHService.swift
//  Channelize-API
//
//  Created by Apple on 1/2/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation
import Alamofire

open class CHService {
    
    internal let messageService: CHMessageService!
    internal let userService: CHUserService!
    internal let chatService: CHChatService!
    
    open static var main: CHService = {
        let service = CHService()
        return service
    }()
    
    private init() {
        userService = CHUserService()
        chatService = CHChatService()
        messageService = CHMessageService()
    }
    
    open func getMessage(messageId: String, completion: @escaping MessageResult){
        self.messageService.getMessage(id: messageId, completion: completion)
    }
    
    //RP
    
    open func getMessages(skip: Int,limit: Int,chatId: String, completion: @escaping MessagesData) {
        let params = ApiFilter.messages(skip: skip, limit: limit).filters()
        self.messageService.getMessages(chatId: chatId, params: params, completion: completion)
    }
    
    open func getMessageCount(chatId: String,completion: @escaping (_ count: Int, _ error:Error?) -> ()) {
        self.messageService.getMessageCount(chatId: chatId, completion: completion)
    }
    //
    
    open func getChat(with userId:String,completion: @escaping ChatData){
        self.messageService.fetchChat(recipientId: userId, completion: completion)
    }
    
    
    /* Channel Services*/
    
    open func getRecentChatCount(completion: @escaping CountResponse){
        self.chatService.getRecentChatCount(completion: completion)
    }
    
    open func getChat(of chatId:String,completion: @escaping ChatData){
        self.chatService.getChat(chatId:chatId , completion: completion)
    }
    
    open func getChats(limit:Int, offset:Int, completion: @escaping ChatsData){
        self.chatService.getChats(skip: offset, limit: limit, completion: completion)
    }
    
    open func getGroupsCount(completion: @escaping CountResponse){
        self.chatService.getGroupsCount(completion: completion)
    }
    
    open func getGroups(limit:Int,offset:Int,completion: @escaping ChatsData){
        self.chatService.getGroups(skip: offset,limit:limit,  completion: completion)
    }
    
    open func createGroup(title:String,memberIds:[String],imageData:Data?,
                          completion: @escaping ChatData){
        let params:Parameters = ["title":title,
                      "ownerId":Channelize.main.currentUserId()!,
                      "members":memberIds]
        self.chatService.createGroup(params: params){[weak self](chat, error) in
            if let error = error {
                return debugPrint(error.localizedDescription)
            }else if let data = imageData{
                if let conversation = chat{
                    self?.chatService.updateProfile(chatId: conversation.id,
                                                    data: data,completion: completion)
                }
            }else{
                completion(chat,error)
            }
        }
    }
    
    
    /* User Services */
    open func getUserCount(completion: @escaping CountResponse){
        self.userService.getUserCount(completion: completion)
    }
    
    open func getUser(with id: String, completion: @escaping UserData){
        self.userService.getUser(id: id, completion: completion)
    }
    
    open func getUsers(limit:Int, offset:Int, completion: @escaping UsersData){
        let params = ApiFilter.contacts(skip: offset, limit: limit).filters()
        self.userService.getContacts(route: .contacts, params: params, completion: completion)
    }
    
    open func getOnlineUsers(completion: @escaping UsersData){
        let params = ApiFilter.onlineContacts(limit:30).filters()
        self.userService.getContacts(route: .contacts, params: params, completion: completion)
    }
    
    open func getBlockedUsers(completion: @escaping UsersData){
        self.userService.getBlockedUsers(completion: completion)
    }
    
    open func getUnreadMessageCount(completion: @escaping CountResponse){
        self.userService.getUnreadMessageCount(completion: completion)
    }
    
    open func blockUser(userId: String, completion: @escaping StatusResponse){
        self.userService.blockUser(userId: userId, completion: completion)
    }
    
    open func unblockUser(userId: String, completion: @escaping StatusResponse){
        self.userService.unblockUser(userId: userId, completion: completion)
    }
    
    // Forward Message
    
    open func forwardMessage(params: Parameters, completion: @escaping (Bool) -> ()){
        self.messageService.forwardMessage(params: params, completion: completion)
    }
}
