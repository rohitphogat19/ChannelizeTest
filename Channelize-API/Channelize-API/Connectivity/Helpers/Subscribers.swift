//
//  Subscribers.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

enum Subscriber {
    
    case
    chatinfo,
    chatMessages,
    deleteConversation,
    clearConversation,
    deleteMessage,
    addMember,
    removeMember,
    addAdmin,
    markMeAsRead,
    markOtherAsRead,
    userTyping,
    blockUser,
    unblockUser,
    blockedUser,
    unblockedUser,
    userOnline,
    offlineUser,
    updateMe
    
    var topic: String {
        switch self {
        case .chatinfo:
            return "users/\(Channelize.main.currentUserId()!)/chats/info" //return Chat object
        case .chatMessages:
            return "users/\(Channelize.main.currentUserId()!)/chats/messages" //returns Message Object
        case .deleteConversation:
            return "users/\(Channelize.main.currentUserId()!)/chats/delete-conversation" //return Chat object
        case .clearConversation:
            return "users/\(Channelize.main.currentUserId()!)/chats/clear-conversation" //return Chat object
        case .deleteMessage:
            return "users/\(Channelize.main.currentUserId()!)/messages/delete" //return Chat object
        case .addMember:
            return "users/\(Channelize.main.currentUserId()!)/add-chat-members" //return Chat Object
        case .removeMember:
            return "users/\(Channelize.main.currentUserId()!)/remove-chat-members" //return Chat Object
        case .addAdmin:
            return "users/\(Channelize.main.currentUserId()!)/chats/add-group-admin" //return {"chatId":chatId,"isAdmin":true,'userId':reqAdminUserId}
            
        case .markMeAsRead:
            return "messageOwner/\(Channelize.main.currentUserId()!)/chats/markAsRead" //return {'messageId':message['id'] , 'chatId':message['chatId'], 'userId':userId , 'messageStatus':ownerStatus}
            
        case .markOtherAsRead:
            return "recipients/\(Channelize.main.currentUserId()!)/chats/markAsRead" //return {'messageId':message['id'] , 'chatId':message['chatId'], 'userId':userId , 'messageStatus':ownerStatus}
        case .userTyping:
            return "users/\(Channelize.main.currentUserId()!)/chats/isTyping" //return {"chatId":chat['id'], "userId":member["userId"],"isTyping":member["isTyping"]}
        case .blockUser:
            return "users/\(Channelize.main.currentUserId()!)/block" //return {userId}
        case .unblockUser:
            return "users/\(Channelize.main.currentUserId()!)/unblock" //return {"loginUser":user,"unblockedUser":customer}
        case .blockedUser:
            return "users/\(Channelize.main.currentUserId()!)/blocked" //return {userId}
        case .unblockedUser:
            return "users/\(Channelize.main.currentUserId()!)/unblocked" //return {"loginUser":user,"unblockedUser":customer}
        case .userOnline:
            return "users/online"
        case .offlineUser:
            return "users/offline"
        case .updateMe:
            return "users/\(Channelize.main.currentUserId()!)" //return user
        }
    }
    
    func value() -> String {
        return topic
    }
    
}

extension Subscriber {
    static var all: [Subscriber] {
        var a: [Subscriber] = []
        switch Subscriber.chatinfo {
        case .chatinfo: a.append(.chatinfo); fallthrough
        case .chatMessages: a.append(.chatMessages); fallthrough
        case .deleteConversation: a.append(.deleteConversation); fallthrough
        case .clearConversation: a.append(.clearConversation); fallthrough
        case .deleteMessage: a.append(.deleteMessage); fallthrough
        case .addMember: a.append(.addMember); fallthrough
        case .removeMember: a.append(.removeMember); fallthrough
        case .addAdmin: a.append(.addAdmin); fallthrough
        case .markMeAsRead: a.append(.markMeAsRead);fallthrough
        case .markOtherAsRead: a.append(.markOtherAsRead);fallthrough
        case .userTyping: a.append(.userTyping); fallthrough
        case .blockUser: a.append(.blockUser); fallthrough
        case .unblockUser: a.append(.unblockUser); fallthrough
        case .blockedUser: a.append(.blockedUser); fallthrough
        case .unblockedUser: a.append(.unblockedUser); fallthrough
        case .userOnline: a.append(.userOnline); fallthrough
        case .offlineUser: a.append(.offlineUser); fallthrough
        case .updateMe: a.append(.updateMe)
        }
        return a
    }
}

enum ChatSubsCribers{
    case messageDeleted(chatId:String)
    
    var topic: String {
        switch self {
        case .messageDeleted(let chatId):
            return "chats/\(chatId)/users/\(Channelize.main.currentUserId()!)/messages-delete"
            //return [String]]
        }
    }
    func value() -> String {
        return topic
    }
}

enum ContactsSubscribers{
    case  addFriend,removeFriend
    var topic: String {
        switch self {
        case .addFriend:
            return "users/\(Channelize.main.currentUserId()!)/add-friend" //return user
        case .removeFriend:
            return "users/\(Channelize.main.currentUserId()!)/remove-friends" //return [userId]
        }
    }
    func value() -> String {
        return topic
    }
}
