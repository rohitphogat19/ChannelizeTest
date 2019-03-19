//
//  Message.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//
import ObjectMapper
import Alamofire

public enum CHMessageType: String {
    case TEXT = "text"
    case IMAGE = "image"
    case VIDEO = "video"
    case AUDIO = "audio"
    case FILE = "file"
    case LINK = "link"
    case STICKER = "sticker"
    case GIF = "gif"
    case LOCATION = "location"
    
}

class Message: CHMessage, Mappable {
    
    var id: String!
    var chatId: String?
    var attachmentType: String?
    var msgStatus: String?
    var body: String? { return _body }
    var ownerId: String?
    var recipients: [CHRecipient]? { return _recipients }
    var owner: CHUser? { return _owner }
    var file: CHFile? { return _file }
    var contentType: Int? = 0
    var metaMessageType: String?
    var metaMessage: CHMetaData? { return _metaMessage }
    var previewUrl: String?
    var messageData: CHMessageData? { return _messageData }
    var quoted: Bool?
    var parentMsgId: String?
    var quotedMessage: CHMessage? { return _quotedMessage }
    var tags: [CHTag]? { return _tags }
    
    private var _messageData: MessageData?
    private var _metaMessage: MetaData?
    private var _quotedMessage: Message?
    private var _recipients: [Recipient]?
    private var _owner: User?
    private var _file: File?
    private var _tags: [Tag]?
    private var _body : String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        chatId <- map["chatId"]
        attachmentType <- map["attachmentType"]
        msgStatus <- map["status"]
        _body <- map["body"]
        ownerId <- map["ownerId"]
        _recipients <- map["recipients"]
        _owner <- map["owner"]
        _file <- map["attachment"]
        contentType <- map["contentType"]
        metaMessageType <- map["metaMessageType"]
        _metaMessage <- map["_metaMessageData"]
        previewUrl <- map["downsampledUrl"]
        _messageData <- map["data"]
        quoted <- map["quoted"]
        parentMsgId <- map["parentMsgId"]
        _quotedMessage <- map["quotedMessage"]
        _tags <- map["tags"]
    }
}

extension Message {
    
    func msgBody(_ conversation: CHConversation) -> String? {
//        print("Debugging -> Content Type \(contentType)")
//        if contentType == 0 {
//            print("Debugging -> Body \(body)")
//            if body != nil {
//                return body!
//            } else {
//                return "Error"
//            }
//        }else {
//            if metaMessage?.msgLabel(conversation, type: metaMessageType!) != nil {
//                return (metaMessage?.msgLabel(conversation, type: metaMessageType!))!
//            } else {
//                return "Meta Message Error"
//            }
//        }
        return contentType! == 0 ? body : metaMessage?.msgLabel(conversation, type: metaMessageType!)
    }
    
    func markAsRead(){
        CHService.main.messageService.markAsRead(messageId: self.id)
    }
    
    func setRecipients(recipients: [CHRecipient]) {
        var recipientArray = [Recipient]()
        for recipient in recipients {
            let recp = Recipient()
            recp.id = recipient.id
            recp.recipientId = recipient.recipientId
            recp.setStatus(status: recipient.status!)
            recp.createdAt = recipient.createdAt
            recipientArray.append(recp)
        }
        self._recipients = recipientArray
    }
    
    func updateMsgStatus(status:Int?,userId:String?,completion: @escaping (_ status: Bool) -> ()){
        var updatedStatus = status
        if(updatedStatus == nil){ updatedStatus = 3 }
        recipients?.forEach({(rec) in
            if(rec.recipientId == userId){
                rec.setStatus(status: updatedStatus!)
            }
            if(rec.recipientId == Channelize.main.currentUserId()){
                rec.setStatus(status: updatedStatus!)
            }
            completion(true)
        })
    }
    
    func updateMessage(updatedMessage:CHMessage) {
        self.id = updatedMessage.id
        self.chatId = updatedMessage.chatId
        self.attachmentType = updatedMessage.attachmentType
        self.msgStatus = updatedMessage.msgStatus
        self._body = updatedMessage.body
        self.ownerId = updatedMessage.ownerId
        self.contentType = updatedMessage.contentType
        self.metaMessageType = updatedMessage.metaMessageType
        self.previewUrl = updatedMessage.previewUrl
        self.quoted = updatedMessage.quoted
        self.parentMsgId = updatedMessage.parentMsgId
        
        /*
         var recipients: [CHRecipient]? { return _recipients }
         var owner: CHUser? { return _owner }
         var file: CHFile? { return _file }
         var metaMessage: CHMetaData? { return _metaMessage }
         var messageData: CHMessageData? { return _messageData }
         var quotedMessage: CHMessage? { return _quotedMessage }
         var tags: [CHTag]? { return _tags }
         
         private var _messageData: MessageData?
         private var _metaMessage: MetaData?
         private var _quotedMessage: Message?
         private var _recipients: [Recipient]?
         private var _owner: User?
         private var _file: File?
         private var _tags: [Tag]?
        */
    }
    
    func updateMessageBody(body: String?) {
        self._body = body
    }
    func isUnread() -> Bool {
        return recipients?.first(where: {$0.recipientId
            == Channelize.main.currentUserId()})?.status == 1
    }
    
}
