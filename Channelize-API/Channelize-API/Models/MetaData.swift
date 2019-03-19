//
//  CHMetaData.swift
//  Channelize-API
//
//  Created by Apple on 12/28/18.
//  Copyright © 2018 Channelize. All rights reserved.
//

import Foundation
import ObjectMapper

class MetaData: CHMetaData, Mappable{
    var id: String!
    var subType: String?
    var subId: String?
    var objType: String?
    var objValues: Any?
    
    init() {}
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        subType <- map["subType"]
        subId <- map["subId"]
        objType <- map["objType"]
        objValues <- map["objValues"]
    }
}

extension MetaData{
    func msgLabel(_ chat:CHConversation?,type:String)->String?{
        var label = ""
        if let chat = chat{
            let subject = (subId == Channelize.main.currentUserId()) ? CHLocalized(key: "pmSelfMemberText") : chat.getUserName(userId: subId)!
            
            switch type {
            case MetaDataType.addMembers.rawValue:
                label = String(format: CHLocalized(key: "pmMetaGroupAddMembers"),
                               arguments: [subject,getObjectString(chat)])
            case MetaDataType.removeMembers.rawValue:
                label = String(format: CHLocalized(key: "pmMetaGroupRemoveMembers"),
                               arguments: [subject,getObjectString(chat)])
            case MetaDataType.changePhoto.rawValue:
                label = String(format: CHLocalized(key: "pmMetaGroupChangePhoto"), arguments: [subject])
            case MetaDataType.changeTitle.rawValue:
                label = String(format: CHLocalized(key: "pmMetaGroupChangeTitle"),
                               arguments: [subject,(objValues as! String).capitalized])
            case MetaDataType.createGroup.rawValue:
                label = String(format: CHLocalized(key: "pmMetaGroupCreate"),
                               arguments: [subject,(objValues as! String).capitalized])
            case MetaDataType.leaveGroup.rawValue:
                label = String(format: CHLocalized(key: "pmMetaGroupLeave"), arguments: [subject])
            case MetaDataType.makeAdmin.rawValue:
                label = String(format: CHLocalized(key: "pmMetaGroupMakeAdmin"), arguments: [subject])
            case MetaDataType.voiceMissed.rawValue:
                label = String(format: CHLocalized(key: "pmMetaCallVoiceMissed"),
                               arguments: [subject,getObjectString(chat)])
            case MetaDataType.videoMissed.rawValue:
                label = String(format: CHLocalized(key: "pmMetaCallVideoMissed"),
                               arguments: [subject,getObjectString(chat)])
            default:
                print("Invalid meta message")
            }
            
        }
        return label
    }
    
    func getObjectString(_ chat:CHConversation?)->String{
        if let type = objType, let obj = objValues, let chat = chat{
            var userIds = [String]()
            if type == "user"{
                var objId = ""
                if let value = obj as? String{
                    objId = value
                }else if let value = obj as? NSNumber  {
                    objId = value.stringValue
                    
                }
                return (objId == Channelize.main.currentUserId()) ? CHLocalized(key: "pmSelfMemberText") :
                    chat.getUserName(userId: objId)!
                
            }else if let values = obj as? [String] {
                userIds = values
            }
            
            var body = ""
            var count = 0
            chat.membersList?.forEach{
                if userIds.contains($0.userId!), let name = $0.user?.displayName{
                    body += name + ", "
                    count += 1
                    if(count == userIds.count){
                        return
                    }
                }
            }
            return String(body.trimmingCharacters(in: .whitespaces).dropLast()).capitalized
        }
        return ""
    }
}


enum MetaDataType: String {
    
    case createGroup = "meta_group_create"
    case leaveGroup = "meta_group_leave"
    case makeAdmin = "meta_group_make_admin"
    case changeTitle = "meta_group_change_title"
    case changePhoto = "meta_group_change_photo"
    case addMembers = "meta_group_add_members"
    case removeMembers = "meta_group_remove_members"
    case voiceMissed = "meta_call_voice_missed"
    case videoMissed = "meta_call_video_missed"
    
}

/*
 
 [[NSNotificationCenter defaultCenter] postNotificationName:kFIRAppReadyToConfigureSDKNotification
 object:self
 userInfo:appInfoDict];
 
 */

