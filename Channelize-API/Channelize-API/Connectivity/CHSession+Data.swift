//
//  File.swift
//  PrimeMessenger
//
//  Created by Ashish on 03/05/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import ObjectMapper

extension CHSession{
    
    func newDataReceived(topic:String, data:Data){
        var json: Any?

        json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        print("Topic is \(topic)")
        switch topic{
        
        case Subscriber.chatinfo.value():
            let chat = Mapper<Conversation>().map(JSONObject: json)
            convDataDelegates.values.forEach({
                $0.didGetChatInfo(conversation:chat)
            })
            return
        case Subscriber.chatMessages.value():
            let message = Mapper<Message>().map(JSONObject: json)
            if(message!.contentType! <= 3){
                convDataDelegates.values.forEach({
                    $0.didReceiveNewMessage(message: message)
                })
            }
            return
        case Subscriber.deleteConversation.value():
            let chat = Mapper<Conversation>().map(JSONObject: json)
            convDataDelegates.values.forEach({
                $0.didDeleteChat(conversation: chat)
            })
            return
        case Subscriber.clearConversation.value():
            let chat = Mapper<Conversation>().map(JSONObject: json)
            convDataDelegates.values.forEach({
                $0.didClearChat(conversation: chat)
            })
            return
        case Subscriber.deleteMessage.value():
            let chat = Mapper<Conversation>().map(JSONObject: json)
            convDataDelegates.values.forEach({
                $0.didDeleteMessage(conversation: chat)
            })
            return
        case Subscriber.addMember.value():
            let chat = Mapper<Conversation>().map(JSONObject: json)
            convDataDelegates.values.forEach({
                $0.didMemberAdded(conversation: chat)
            })
            return
        case Subscriber.removeMember.value():
            let chat = Mapper<Conversation>().map(JSONObject: json)
            convDataDelegates.values.forEach({
                $0.didMemberRemoved(conversation: chat)
            })
            return
        case Subscriber.addAdmin.value():
            if let JSON = json as? [String: Any] {
                convDataDelegates.values.forEach({
                    $0.didAdminAdded(conversationId: JSON["chatId"] as? String,
                                     isAdmin: JSON["isAdmin"] as! Bool,
                                     userId: JSON["userId"] as? String)
                })
            }
            return
        case Subscriber.markMeAsRead.value():
            if let JSON = json as? [String: Any] {
                convDataDelegates.values.forEach({
                    $0.didMarkAsRead(messageId: JSON["messageId"] as? String,
                                     conversationId: JSON["chatId"] as? String,
                                     userId: JSON["userId"]as? String,
                                     status: JSON["messageStatus"] as? Int,
                                     isMe: true)
                })
            }
            return
        case Subscriber.markOtherAsRead.value():
            if let JSON = json as? [String: Any] {
                convDataDelegates.values.forEach({
                    $0.didMarkAsRead(messageId: JSON["messageId"] as? String,
                                     conversationId: JSON["chatId"] as? String,
                                     userId: JSON["userId"]as? String,
                                     status: JSON["messageStatus"] as? Int,
                                     isMe: false)
                })
            }
            return
        case Subscriber.userTyping.value():
            if let JSON = json as? [String: Any] {
                convDataDelegates.values.forEach({
                    $0.didChangeTypingStatus(conversationId: JSON["chatId"] as? String,
                                              userId: JSON["userId"] as? String,
                                              isTyping: JSON["isTyping"] as! Bool)
                })
                
            }
            return
        case Subscriber.blockUser.value():
            if let JSON = json as? [String] {
                contactDelegates.values.forEach({
                    $0.didUserBlocked(isMe: false, userId: JSON[0])
                })
            }
            return
        case Subscriber.blockedUser.value():
            if let JSON = json as? [String] {
                contactDelegates.values.forEach({
                    $0.didUserBlocked(isMe: true, userId: JSON[0])
                })
            }
            return
        case Subscriber.unblockUser.value():
            if let JSON = json as? [String: Any] {
                let unblockedUser = Mapper<User>().map(JSONObject: JSON["unblockedUser"])
                contactDelegates.values.forEach({
                    $0.didUserUnblocked(isMe: false, user: unblockedUser)
                })
            }
            return
        case Subscriber.unblockedUser.value():
            if let JSON = json as? [String: Any] {
                //let unblockedUser = Mapper<User>().map(JSONObject: JSON["unblockedUser"])
                let loginUser = Mapper<User>().map(JSONObject: JSON["loginUser"])
                contactDelegates.values.forEach({
                    $0.didUserUnblocked(isMe: true, user: loginUser)
                })
            }
            return
        case Subscriber.userOnline.value():
            let user = Mapper<User>().map(JSONObject: json)
            if let JSON = json as? [String: Any] {
                
                if let blockList = JSON["blockList"] as? [String]{
                    user?.setHasBlocked(status: blockList.contains(Channelize.main.currentUserId()!))
                }
                if let blockedList = JSON["blockedList"] as? [String]{
                    user?.setIsBlocked(status: blockedList.contains(Channelize.main.currentUserId()!))
                }
                if let friendList = JSON["friendList"] as? [String], friendList.contains(Channelize.main.currentUserId()!){
                    contactDelegates.values.forEach({
                        $0.didChangeUserStatus(user: user)
                    })
                }
            }
            contactDelegates.values.forEach({
                $0.didChangeUserStatus(user: user)
            })
            return
        case Subscriber.offlineUser.value():
            let user = Mapper<User>().map(JSONObject: json)
            contactDelegates.values.forEach({
                $0.didChangeUserStatus(user: user)
            })
            
            return
            
        case ContactsSubscribers.addFriend.value():
            let user = Mapper<User>().map(JSONObject: json)
            contactDelegates.values.forEach({
                $0.didUserAdded(user: user)
            })
            return
        case ContactsSubscribers.removeFriend.value():
            let user = Mapper<User>().map(JSONObject: json)
            contactDelegates.values.forEach({
                $0.didUserRemoved(user: user)
            })
            return
        case Subscriber.updateMe.value():
            //let user = Mapper<User>().map(JSONObject: json)
            return
        default:
            if(topic.contains("messages-delete")){
                if let JSON = json as? [String] {
                    convDataDelegates.values.forEach({
                        $0.didMessagesDeleted(messageIds: JSON,topic:topic)
                    })
                }
                
            }
        }
    }
}
