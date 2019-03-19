//
//  SubscriberDataDelegate.swift
//  PrimeMessenger
//
//  Created by Ashish on 16/05/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

public protocol CHConversationDataDelegate{
    
    func didGetChatInfo(conversation: CHConversation?)
    func didReceiveNewMessage(message: CHMessage?)
    func didDeleteChat(conversation: CHConversation?)
    func didClearChat(conversation: CHConversation?)
    func didDeleteMessage(conversation: CHConversation?)
    func didMemberAdded(conversation: CHConversation?)
    func didMemberRemoved(conversation: CHConversation?)
    func didAdminAdded(conversationId:String?, isAdmin:Bool, userId:String?)
    func didMarkAsRead(messageId:String?,conversationId:String?,userId:String?,status:Int?,isMe:Bool)
    func didChangeTypingStatus(conversationId:String?,userId:String?,isTyping:Bool)
    func didMessagesDeleted(messageIds:[String],topic:String)
    
}

public extension CHConversationDataDelegate{
    func didDeleteChat(conversation: CHConversation?){}
    func didClearChat(conversation: CHConversation?){}
    func didMarkAsRead(messageId:String?,conversationId: String?, userId:String?, status:Int?, isMe:Bool){}
    func didChangeTypingStatus(conversationId:String?,userId:String?,isTyping:Bool){}
    func didMessagesDeleted(messageIds:[String],topic:String){}
}
