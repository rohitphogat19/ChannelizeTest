//
//  Conversation+Publishers.swift
//  Channelize-API
//
//  Created by Ashish-BigStep on 1/17/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension Conversation {
    
    fileprivate func getMessageObject(_ params:Parameters)->Message{
        let message = Mapper<Message>().map(JSONObject: params)
        return message!
    }
    
    func addNewMessage(params:Parameters){
        //self.quotedMessageModel = nil
        //self.dataSource.addNewMessage(params: params)
        //if(self.dataSource.chat != nil){
          //  publishMessage(params)
        //}else{
          //  self.dataSource.sendMessage(params)
        //}
    }
    
    
    func publishMessage(_ params:Parameters){
        
        DispatchQueue.global(qos: .background).async {
            var newParams = params
            let owner = ["id":"","displayName":""]
            newParams.updateValue(owner, forKey: "owner")
            CHSession.shared.publish(data: newParams, topic: "users/server/chat/messages")
            self.membersList?.forEach({(member) in
                if(member.isActive!){
                    let chatTopic = "users/\(member.userId!)/chats/\(self.id!)/messages"
                    let globalTopic = "users/\(member.userId!)/chats/messages"
                    CHSession.shared.publish(data: newParams, topic: chatTopic)
                    CHSession.shared.publish(data: newParams, topic: globalTopic)
                }
            })
        }
        
    }
    
    func publishReadStatus(message:CHMessage){
        DispatchQueue.global(qos: .background).async {
            
            let params:Parameters = ["messageId":message.id,"userId":Channelize.main.currentUserId()!,
                                     "chatId":self.id,"userMessageStatus":3]
            let ownerTopic = "chats/\(self.id)/messageOwner/\(message.ownerId!)/markAsRead"
            let ownerTopic2 = "messageOwner/\(message.ownerId!)/chats/markAsRead"
            let chatTopic = "chats/\(self.id)/recipient/\(Channelize.main.currentUserId()!)/markAsRead"
            let recipientTopic = "recipients/\(Channelize.main.currentUserId()!)/chats/markAsRead"
            CHSession.shared.publish(data: params, topic: "server/markAsRead")
            CHSession.shared.publish(data: params, topic: ownerTopic)
            CHSession.shared.publish(data: params, topic: ownerTopic2)
            CHSession.shared.publish(data: params, topic: chatTopic)
            CHSession.shared.publish(data: params, topic: recipientTopic)
            
        }
    }
    
    func publishTypingStatus(isTyping:Bool){
        DispatchQueue.global(qos: .background).async {
            
            let params:Parameters = ["userId":Channelize.main.currentUserId()!,
                                     "isTyping":isTyping,
                                     "chatId":self.id]
            CHSession.shared.publish(data: params, topic: "chats/\(self.id)/isTyping")
            self.membersList?.forEach({(member) in
                if(member.isActive! && member.userId! != Channelize.main.currentUserId()!){
                    CHSession.shared.publish(data: params, topic: "users/\(member.userId!)/chats/isTyping")
                }
            })
            
        }
    }
}
