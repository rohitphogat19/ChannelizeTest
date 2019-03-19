//
//  Conversation+Services.swift
//  Channelize-API
//
//  Created by Ashish-BigStep on 1/17/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

//Interfaces methods used for service requests
extension Conversation {
    
    func getMessageCount(completion: @escaping CountResponse){
        CHService.main.messageService.getMessageCount(chatId: self.id, completion:completion)
    }
    
    func getMessages(limit: Int? = 0, offset: Int? = 0, completion: @escaping MessagesData) {
        let params = ApiFilter.messages(skip: offset!, limit: limit!).filters()
        CHService.main.messageService.getMessages(chatId: self.id,
                                                  params: params,
                                                  completion: completion)
    }
    
    func deleteMessages(messageIds:[String],completion: @escaping StatusResponse){
        CHService.main.messageService.deleteMessages(params:["messageIds":messageIds],
                                                     completion: completion)
    }
    
    func clear(completion: @escaping StatusResponse){
        CHService.main.chatService.clearChat(chatId: self.id, completion: completion)
    }
    
    func delete(completion: @escaping StatusResponse){
        CHService.main.chatService.deleteChat(chatId: self.id, completion: completion)
    }
    
    func changeTitle(title:String, completion: @escaping  ChatData){
        CHService.main.chatService.changeTitle(chatId: self.id,
                                               params: ["title":title],
                                               completion: completion)
    }
    
    func updateProfileImage(data:Data, completion: @escaping  ChatData){
        CHService.main.chatService.updateProfile(chatId: self.id,
                                                 data: data,
                                                 completion: completion)
    }
    
    func makeAdmin(userId: String, completion: @escaping StatusResponse) {
        CHService.main.chatService.addGroupAdmin(chatId: self.id,
                                                 params: ["userId":userId],
                                                 completion: completion)
    }
    
    func addMembers(userIds: [String], completion: @escaping ChatData) {
        CHService.main.chatService.addMembers(chatId: self.id,
                                              params: ["members":userIds],
                                              completion: completion)
    }
    
    func removeMembers(userIds:[String], completion: @escaping StatusResponse){
        CHService.main.chatService.removeChatMembers(chatId: self.id,
                                                     params: ["members":userIds],
                                                     completion: completion)
    }
    
    func leave(completion: @escaping StatusResponse){
        CHService.main.chatService.leaveChat(chatId: self.id, completion: completion)
    }
    
    func markAllMessagesAsRead(){
        CHService.main.messageService.markAllAsRead(chatId: self.id)
    }
    
    func sendMessage(text: String?, data: Data?, fileUrl: URL?, type: CHMessageType, params: Parameters, progress: @escaping UploadProgress, completion: @escaping MessageResult) {
//        var params = ["id":UUID().uuidString,
//                      "ownerId":Channelize.main.currentUserId()!,
//                      "chatId":self.id!,
//                      "attachmentType":type.rawValue]
        if type == .TEXT {
            //params.updateValue(text!, forKey: "body")
            CHService.main.messageService.sendMessage(params: params as Parameters, completion: {(message,error) in
                guard error == nil else { progress(0.0)
                    completion(nil,error)
                    return }
                progress(1.0)
                completion(message,nil)
            })
        } else {
            let messageMimeType : CHMimeType?
            if type == .AUDIO {
                messageMimeType = .Audio
            } else if type == .IMAGE {
                messageMimeType = .Image
            } else if type == .VIDEO {
                messageMimeType = .Video
            } else {
                messageMimeType = .Image
            }
            if data != nil {
                CHService.main.messageService.sendMessage(data: data!, params: params, mimeType: messageMimeType!, completion: {(result) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (progress) in
                            
                        })
                        upload.responseJSON { response in
                            print("Debugging Data Response -> \(response)")
                            if let JSON = response.result.value as? NSDictionary {
                                let message = Mapper<Message>().map(JSONObject: JSON)
                                completion(message,nil)
                            }
                        }
                    case .failure(let encodingError):
                        completion(nil,encodingError)
                    }
                })
            } else if fileUrl != nil {
                CHService.main.messageService.sendMessage(fileUrl: fileUrl!, params: params, completion: {(result) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (progress) in
                            
                        })
                        upload.responseJSON { response in
                            print("Debugging Data Response -> \(response)")
                            if let JSON = response.result.value as? NSDictionary {
                                let message = Mapper<Message>().map(JSONObject: JSON)
                                completion(message,nil)
                            }
                        }
                    case .failure(let encodingError):
                        completion(nil,encodingError)
                    }
                })
            }
        }
    }
    
    func sendMessage(data:Data, type:CHMessageType, completion: @escaping MessageResult) {
        let params = ["id":UUID().uuidString,
                      "ownerId":Channelize.main.currentUserId()!,
                      "chatId":self.id!,
                      "attachmentType":type.rawValue]
        CHService.main.messageService.sendMessage(data: data, params: params, completion: {(result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Debugging -> \(progress.fractionCompleted)")
                    //photoModel.transferProgress = progress.fractionCompleted
                })
                
                upload.responseJSON { response in
                    if let JSON = response.result.value as? NSDictionary {
                        let message = Mapper<Message>().map(JSONObject: JSON)
                        completion(message,nil)
                    }
                    //model.transferStatus = .success
                }
            case .failure(let encodingError):
                completion(nil,encodingError)
            }
        })
        
        
    }
    
    func sendMessage(fileUrl:URL, type:CHMessageType, completion: @escaping MessageResult) {
        let params = ["id":UUID().uuidString,
                      "ownerId":Channelize.main.currentUserId()!,
                      "chatId":self.id!,
                      "attachmentType":type.rawValue]
        CHService.main.messageService.sendMessage(fileUrl: fileUrl, params: params, completion: {(result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    //photoModel.transferProgress = progress.fractionCompleted
                })
                
                upload.responseJSON { response in
                    if let json = response.result.value as? NSDictionary {
                        let message = Mapper<Message>().map(JSONObject: json)
                        completion(message,nil)
                    }
                    //model.transferStatus = .success
                }
            case .failure(let encodingError):
                completion(nil,encodingError)
            }
        })
        
    }
    
    func sendMessage(data:Data, type:CHMessageType, params:Parameters, progess: @escaping UploadProgress, completion: @escaping MessageResult){
        
        let messageMimeType : CHMimeType?
        if type == .AUDIO {
            messageMimeType = .Audio
        } else if type == .IMAGE {
            messageMimeType = .Image
        } else if type == .VIDEO {
            messageMimeType = .Video
        } else {
            messageMimeType = .Image
        }
        
        CHService.main.messageService.sendMessage(data: data, params: params, mimeType: messageMimeType!, completion: {(result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    progess(progress.fractionCompleted)
                })
                
                upload.responseJSON { response in
                    print("Debugging Data Response -> \(response)")
                    if let JSON = response.result.value as? NSDictionary {
                        let message = Mapper<Message>().map(JSONObject: JSON)
                        completion(message,nil)
                    }
                }
            case .failure(let encodingError):
                completion(nil,encodingError)
            }
        })
    }
    
    
    func sendMessage(data:Data, type:CHMessageType, params:Parameters, completion: @escaping MessageResult){
        
        CHService.main.messageService.sendMessage(data: data, params: params, mimeType: .Audio, completion: {(result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Debugging -> \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print("Debugging Data Response -> \(response)")
                    if let JSON = response.result.value as? NSDictionary {
                        let message = Mapper<Message>().map(JSONObject: JSON)
                        completion(message,nil)
                    }
                }
            case .failure(let encodingError):
                completion(nil,encodingError)
            }
        })
    }
    
    func sendMessage(fileUrl:URL, type:CHMessageType, params:Parameters, completion: @escaping MessageResult){
        
        CHService.main.messageService.sendMessage(fileUrl: fileUrl, params: params, completion: {(result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    //photoModel.transferProgress = progress.fractionCompleted
                })
                
                upload.responseJSON { response in
                    if let JSON = response.result.value as? NSDictionary {
                        let message = Mapper<Message>().map(JSONObject: JSON)
                        completion(message,nil)
                    }
                    //model.transferStatus = .success
                }
            case .failure(let encodingError):
                completion(nil,encodingError)
            }
        })
    }
    
    func sendMessage(text:String, completion: @escaping MessageResult){
        let params = ["id":UUID().uuidString,
                      "ownerId":Channelize.main.currentUserId()!,
                      "chatId":self.id!,
                      "body":text,
                      "attachmentType":"text"]
        CHService.main.messageService.sendMessage(params: params as Parameters, completion: completion)
        
    }
    
    func sendQuotedMessage(text:String, quotedMessage:CHMessage, completion: @escaping MessageResult){
        
    }
    
    func forwardMessage(params: Parameters, completion: @escaping (Bool) -> ()) {
       // CHService.main.messageService.forwardMessage(params: params, completion: completion)
    }
    
    
}
