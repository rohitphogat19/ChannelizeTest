//
//  Conversation.swift
//  Channelize-API
//
//  Created by Apple on 1/5/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation
import Alamofire

public protocol CHConversation {
    
    var id: String! { get }
    var title: String? { get }
    var memberCount: Int! { get }
    var isGroup: Bool? { get }
    var ownerId: String? { get }
    var resourceType: String? { get }
    var profileImageUrl: String? { get }
    var createdAt: Date? { get }
    var members : [String:String]? { get }
    var membersList: [CHMember]? { get }
   
    /* API Methods START */
    
    func markAllMessagesAsRead()
    func getMessageCount(completion: @escaping CountResponse)
    func getMessages(limit:Int?, offset:Int?, completion: @escaping MessagesData)
    func deleteMessages(messageIds:[String], completion: @escaping StatusResponse)
    
    func clear(completion: @escaping StatusResponse)
    func delete(completion: @escaping StatusResponse)
    func leave(completion: @escaping StatusResponse)
    
    func changeTitle(title:String, completion: @escaping  ChatData)
    func updateProfileImage(data:Data, completion: @escaping ChatData)
    
    func removeMembers(userIds:[String], completion: @escaping StatusResponse)
    func makeAdmin(userId:String, completion: @escaping StatusResponse)
    func addMembers(userIds:[String], completion: @escaping ChatData)
    
    func sendMessage(text:String?,data:Data?,fileUrl:URL?,type:CHMessageType,params:Parameters, progress: @escaping UploadProgress, completion: @escaping MessageResult)
    func sendMessage(data:Data, type:CHMessageType, params:Parameters, progess: @escaping UploadProgress, completion: @escaping MessageResult)
    func sendMessage(data:Data, type:CHMessageType, params:Parameters, completion: @escaping  MessageResult)
    func sendMessage(fileUrl:URL, type:CHMessageType, params:Parameters, completion: @escaping MessageResult)
    func sendMessage(data:Data, type:CHMessageType, completion: @escaping  MessageResult)
    func sendMessage(fileUrl:URL, type:CHMessageType, completion: @escaping MessageResult)
    func sendMessage(text:String, completion: @escaping MessageResult)
    func sendQuotedMessage(text:String, quotedMessage:CHMessage, completion: @escaping MessageResult)
    func forwardMessage(params: Parameters, completion: @escaping (Bool) -> ())
    
    func partner() -> CHMember?
    
    func getNewMessageCount()->Int
    
    func getDeletedMember(_ id:String) -> CHUser
    
    func currentMember() -> CHMember?
    
    func updateMessageBody()
    
    func updateAdmin(userId:String, status:Bool)
    
    func removeMessageCount()
    
    func getRecipients(status:Int)-> [CHRecipient]?
    
    func updateNewMessage(message: CHMessage)
    
    func updateMessageCount()
    
    func updateTypingStatus(userId:String,status:Bool)
    
    func getUserName(userId:String?)-> String?
    
    func publishMessageReadStatus(message: CHMessage)
    
    func updateActiveStatus(isMe:Bool,status:Bool,userId:String?)
    
    func isTyping()-> String?
    
    func publishUserTypingStatus(isTyping:Bool)
    
    func publishMessage(_ params:Parameters)
}


