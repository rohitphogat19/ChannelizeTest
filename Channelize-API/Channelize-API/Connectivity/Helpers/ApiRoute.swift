//
//  ApiRoute.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

enum ApiRoute { case
    
    login,
    chatCount,
    userCount,
    countMessage(chatId: String),
    chat(id: String),
    allChats,
    searchChats,
    oneToOne(recipientId: String),
    user(id: String),
    contacts,
    blockedUsers,
    messages(chatId: String),
    message(id: String),
    markAsRead(messageId:String),
    markAllAsRead(chatId:String),
    sendMessage,
    forwardMessage,
    location,
    deleteMessages,
    postNewChat,
    postChat(chatId:String),
    chageTitle(chatId:String),
    updateChat(chatId: String),
    addMembers(chatId: String),
    removeMembers(chatId:String),
    makeAdmin(chatId:String),
    clearChat(chatId:String),
    deleteChat(chatId:String),
    blockUser,
    unblockUser,
    leaveChat(chatId:String),
    fcmToken,
    unreadMsgCount,
    getModules
    
    var path: String {
        switch self {
            
        case .login:
            return "customers/login?include=user"
        case .chatCount:
            return "customers/\(Channelize.main.currentUserId()!)/chats/count"
        case .userCount:
            return "customers/\(Channelize.main.currentUserId()!)/friends/count"
        case .countMessage(let chatId):
            return "chats/\(chatId)/messages/count"
        case .chat(let id):
            return "chats/\(id)"
        case .allChats:
            return "customers/\(Channelize.main.currentUserId()!)/chats"
        case .searchChats:
            return "customers/\(Channelize.main.currentUserId()!)/searchChats"
        case .oneToOne(let recipientId):
            return "customers/\(Channelize.main.currentUserId()!)/oneToOneChats/\(recipientId)"
        case .user(let id):
            return "customers/\(id)"
        case .contacts:
            return "customers/\(Channelize.main.currentUserId()!)/friend-list"
        case .blockedUsers:
            return "customers/\(Channelize.main.currentUserId()!)/block-list"
        case .message(let id):
            return "messages/\(id)"
        case .messages(let chatId):
            return "chats/\(chatId)/messages"
        case .sendMessage:
            return "messages/send"
        case .forwardMessage:
            return "messages/forward"
        case .location:
            return "messages/location"
        case .markAsRead(let messageId):
            return "messages/markAsRead/\(messageId)"
        case .markAllAsRead(let chatId):
            return "chats/\(chatId)/user/\(Channelize.main.currentUserId()!)/markAllAsRead"
        case .postNewChat:
            return "chats"
        case .postChat(let chatId):
            return "chats/\(chatId)"
        case .chageTitle(let chatId):
            return "customers/\(Channelize.main.currentUserId()!)/changeChatTitle/\(chatId)"
        case .updateChat(let chatId):
            return "customers/\(Channelize.main.currentUserId()!)/changeChatProfile/\(chatId)"
        case .addMembers(let chatId):
            return "customers/\(Channelize.main.currentUserId()!)/chats/\(chatId)/add-chat-members"
        case .removeMembers(let chatId):
            return "customers/\(Channelize.main.currentUserId()!)/chats/\(chatId)/remove-chat-members"
        case .makeAdmin(let chatId):
            return "customers/\(Channelize.main.currentUserId()!)/addGroupAdmin/\(chatId)"
        case .clearChat(let chatId):
            return "customers/\(Channelize.main.currentUserId()!)/clearConversation/\(chatId)"
        case .deleteChat(let chatId):
            return "customers/\(Channelize.main.currentUserId()!)/deleteConversation/\(chatId)"
        case .deleteMessages:
            return "customers/\(Channelize.main.currentUserId()!)/deleteMessages"
        case .blockUser:
            return "customers/\(Channelize.main.currentUserId()!)/block"
        case .unblockUser:
            return "customers/\(Channelize.main.currentUserId()!)/unblock"
        case .leaveChat(let chatId):
            return "customers/\(Channelize.main.currentUserId()!)/chats/\(chatId)/leave-chat"
        case .fcmToken:
            return "customers/\(Channelize.main.currentUserId()!)/fcmTokens"
        case .unreadMsgCount:
            return "customers/\(Channelize.main.currentUserId()!)/unread-messages/count"
        case .getModules:
            return "pmModule"
            
        }
    }
    
    func url() -> String {
        //let developement = "https://phn86j6grl.execute-api.us-east-1.amazonaws.com/dev/modules"
        let production = "https://api.primemessenger.com/v1/modules"
        return path != "pmModule" ? "\(Channelize.main.apiPath())/\(path)" : production
    }
}
