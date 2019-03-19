//
//  CHChat.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//
import Foundation
import Alamofire
import ObjectMapper

class Conversation : CHConversation, Mappable {
    
    var id: String!
    var title: String?
    var memberCount: Int!
    var isGroup: Bool?
    var ownerId: String?
    var resourceType: String?
    var profileImageUrl: String?
    var createdAt: Date?
    var membersList: [CHMember]? { return _members }
    var members: [String : String]? { return _memberNames}
    
    fileprivate var _members = [Member]()
    fileprivate var _current: Member?
    fileprivate var _other: Member?
    fileprivate var _memberNames = [String:String]()
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        title <- map["title"]
        memberCount <- map["memberCount"]
        isGroup <- map["isGroup"]
        ownerId <- map["ownerId"]
        resourceType <- map["resourceType"]
        profileImageUrl <- map["profileImageUrl"]
        createdAt <- (map["createdAt"], ISODateTransform())
        _members <- map["membersList"]
        updateMemberList()
    }
}

extension Conversation {
    
    func updateMemberList(){
        _members.forEach{(member) in
            if let name = member.user?.displayName{
                _memberNames.updateValue(name, forKey: member.userId!)
            }
            if member.userId == Channelize.main.currentUserId() {
                _current = member
            }else{
                _other = member
            }
        }
    }

    func updateMessageBody(){
        if let tags = _current?.message?.tags?.sorted(by: { $0.order! < $1.order! }),tags.count > 0{
            var names = [String]()
            for tag in tags{
                if let name = _memberNames[tag.userId!]?.capitalized{
                    if tag.wordCount == 1{
                        var components = name.components(separatedBy: " ")
                        names.append(components.removeFirst())
                    }else{
                        names.append(name)
                    }
                }
            }
            _current?.message?.updateMessageBody(body: String(format: _current!._message!.body!.replacingOccurrences(of: "%s", with: "%@"),arguments: names))
        }
    }

    func currentMember() -> CHMember?{
        return _current
    }
    
    func partner() -> CHMember?{
        return _other
    }

    func updateAdmin(userId:String, status:Bool){
        _members.first(where: {$0.userId == userId})?.isAdmin = status
    }

    func updateNewMessage(message: CHMessage){
        //let newMessage = Message()
        //newMessage.updateMessage(updatedMessage: message)
        _current?._message = message as! Message
    }

    func updateMessageCount(){
        if let currentMember = _current, currentMember.message?.contentType != 1{
            currentMember.newMessageCount! = (currentMember.newMessageCount! + 1)
        }
    }
    
    func removeMessageCount(){
        _current?.newMessageCount = 0
    }
    
    func updateTypingStatus(userId:String,status:Bool){
        _members.first(where: {$0.userId == userId})?.isTyping = status
    }

    func updateActiveStatus(isMe:Bool,status:Bool,userId:String?){
        if(isMe){
            _members.first(where: {$0.userId == userId})?.isActive = status
        }else{
            _members.first(where: {$0.userId == Channelize.main.currentUserId()})?.isActive = status
        }
    }
    
    func isTyping()-> String?{
        let member = membersList?.first(where:{$0.userId != Channelize.main.currentUserId()  && $0.isTyping!})
        if(member != nil && member?.user != nil){
            return isGroup! ? String(format: CHLocalized(key: "pmUserTyping"), member!.user!.displayName!.components(separatedBy: " ").first!).capitalized : CHLocalized(key: "pmTyping")
        }
        return nil
    }
    
    func getAdminCount() -> Int{
        let admins = membersList?.filter({$0.isAdmin!})
        return admins != nil ? admins!.count : 0
    }

    func getNewMessageCount()->Int{
        return _current?.newMessageCount != nil ? _current!.newMessageCount! : 0
    }
    
    func getParticipantsNames()->String{
        var name = ""
        membersList?.forEach{
            if($0.user?.displayName != nil){
                name += ($0.user?.displayName)! + ","
            }
        }
        return String(name.dropLast())
    }
    
    func getUserName(userId:String?)-> String?{
        let user = membersList?.first(where: {$0.userId == userId})?.user
        if(user != nil){
            return user?.displayName?.capitalized
        }
        return getDeletedMember(userId!).displayName?.capitalized
    }
    
    func getRecipients(status:Int)-> [CHRecipient]?{
        var recipients = [Recipient]()
        membersList?.forEach({(member) in
            if(member.isActive!){
                let recipient = Recipient()
                recipient.id = UUID().uuidString
                recipient.recipientId = member.userId!
                recipient.createdAt = Date()
                if(member.userId! != Channelize.main.currentUserId()!){
                    recipient.setStatus(status: status)
                    //recipient.status = status
                }else{
                    recipient.setStatus(status: 3)
                    //recipient.status = 3
                }
                recipients.append(recipient)
            }
        })
        return recipients
    }
    
    func getDeletedMember(_ id:String) -> CHUser {
        let user = User()
        user.id = id
        user.displayName = CHLocalized(key: "pmDeletedUser")
        user.profileImageUrl = nil
        user.setOnlineStatus(status: false)
        user.language = "en"
        user.notification = false
        user.uVisibility = false
        user.profileUrl = nil
        user.lastSeen = nil
        return user
    }
    
    func publishMessageReadStatus(message: CHMessage) {
        self.publishReadStatus(message: message)
    }
    
    func publishUserTypingStatus(isTyping:Bool) {
        self.publishTypingStatus(isTyping: isTyping)
    }
}



