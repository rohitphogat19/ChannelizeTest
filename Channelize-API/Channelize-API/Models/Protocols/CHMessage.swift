//
//  Message.swift
//  Channelize-API
//
//  Created by Apple on 1/5/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation

// : CHMessageModelProtocol
public protocol CHMessage {
    
    var id: String! { get }
    var chatId: String? { get }
    var attachmentType: String? { get }
    var msgStatus: String? { get }
    var body: String? { get }
    var ownerId: String? { get }
    var recipients: [CHRecipient]? { get }
    var owner: CHUser? { get }
    var file: CHFile? { get }
    var contentType:Int? { get }
    var metaMessageType:String? { get }
    var metaMessage:CHMetaData? { get }
    var previewUrl:String? { get }
    var messageData: CHMessageData? { get }
    var quoted: Bool? { get }
    var parentMsgId: String? { get }
    var quotedMessage: CHMessage? { get }
    var tags: [CHTag]? { get }
    
    func markAsRead()
    func updateMsgStatus(status:Int?,userId:String?,completion: @escaping (_ status: Bool) -> ())
    func setRecipients(recipients: [CHRecipient])
    func msgBody(_ conversation:CHConversation) -> String?
    func updateMessageBody(body:String?)
    func isUnread() -> Bool
}

