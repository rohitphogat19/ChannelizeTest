//
//  ApiFilters.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//
import Alamofire

enum ApiFilter { case
    
    chat,
    chatCount,
    groupCount,
    recentChats(skip: Int,limit:Int),
    groups(skip: Int,limit:Int),
    contacts(skip: Int,limit:Int),
    messages(skip: Int,limit:Int),
    messageCount,
    searchContacts(query:String),
    onlineContacts(limit:Int)
    
    var filter : Any {
        switch self {
        
        case .chatCount:
            return ["where":["_membersList.isDeleted":"false"]]
            
        case .groupCount:
            return ["where":["isGroup":"true","_membersList.isActive":"true"]]
            
        case .chat:
            return ["include":"membersList",
                    "where":["_membersList.isDeleted":"false"],
                    "order":["_membersList.updatedAt": -1]]
            
        case .recentChats(let skip,let limit):
            return ["skip":skip,
                    "limit":limit,
                    "include":"membersList",
                    "where":["_membersList.isDeleted":"false"],
                    "order":["_membersList.updatedAt": -1]]
            
            
        case .groups(let skip,let limit):
            return ["include":"membersList",
                    "order":["_membersList.updatedAt": -1],
                    "where":["isGroup":"true","_membersList.isActive":"true"],
                    "limit":limit,
                    "skip":skip]
            
        case .contacts(let skip,let limit):
            return ["order":"displayName ASC",
                    "limit":limit,
                    "skip":skip]
            
        case .messages(let skip,let limit):
            return ["order":["recipients.createdAt":-1],
                    "where":["recipients.recipientId":Channelize.main.currentUserId()!,
                             "status":"success",
                             "attachmentType":["neq":"link"],
                             "contentType":["lt":4]],
                    "limit":limit,
                    "skip":skip]
            
        case .messageCount:
            return ["recipients.recipientId":Channelize.main.currentUserId()!,
                    "status":"success",
                    "attachmentType":["neq":"link"],
                    "contentType":["lt":3]]
            
        case .searchContacts(let query):
            return ["order":"displayName ASC",
                    "where":["displayName": ["like": query+".*","options":"i"]]]
            
        case .onlineContacts(let limit):
            return ["order":"displayName ASC",
                    "where":["isOnline":"true"],
                    "limit":limit]
            
        }
    }
    
    func filters() -> Parameters {
        return ["filter":filter]
    }
}
