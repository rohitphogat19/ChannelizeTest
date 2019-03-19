//
//  AlamofireMessageService.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class CHMessageService: MessageService {
    //RP
    
    //
    
   
    func fetchChat(recipientId: String, completion: @escaping ChatData) {
        let params = ["filter":["include":"membersList"]]
        CHApi.shared.get(at: .oneToOne(recipientId: recipientId),params: params).responseObject {(res: DataResponse<Conversation>) in
            completion(res.result.value, res.result.error)
        }
    }
    
    func getChat(chatId: String, completion: @escaping ChatData) {
        let params = ["filter":["include":"membersList"]]
        CHApi.shared.get(at: .chat(id: chatId),params: params).responseObject {(res: DataResponse<Conversation>) in
            completion(res.result.value, res.result.error)
        }
    }
    
    func getMessageCount(chatId: String,completion: @escaping CountResponse) {
        let param = ApiFilter.messageCount.filters()
        CHApi.shared.get(at: .countMessage(chatId: chatId),params:param ).responseJSON{
            (res: DataResponse<Any>) in
            switch res.result{
            case .success(let data):
                let dict = data as! [String:Int]
                let count = dict["count"]
                completion(count!, nil)
            case .failure(let error):
                completion(0, error)
            }
        }
    }
    
    func getMessage(id: String, completion: @escaping MessageResult) {
        CHApi.shared.get(at: .message(id: id)).responseObject {
            (res: DataResponse<Message>) in
            completion(res.result.value, res.result.error)
        }
    }
    
    func getMessages(chatId: String, params:Parameters, completion: @escaping MessagesData) {
        CHApi.shared.get(at: .messages(chatId: chatId),params:params).responseArray {
            (res: DataResponse<[Message]>) in
            completion(res.result.value ?? [], res.result.error)
        }
    }
    
    func getCustomMessages(chatId: String, params:Parameters, completion: @escaping MessagesData) {
        CHApi.shared.get(at: .messages(chatId: chatId),params:params).responseArray {
            (res: DataResponse<[Message]>) in
            completion(res.result.value ?? [], res.result.error)
        }
    }
    
    //POST
    func sendMessage(data: Data,params: Parameters, completion: @escaping ((SessionManager.MultipartFormDataEncodingResult) -> Void)) {
        CHApi.shared.upload(at: .sendMessage, data: data,params: params,mimeType: .Image){
            encodingResult in
            completion(encodingResult)
        }
    }
    
    func sendMessage(data: Data,params: Parameters,mimeType:CHMimeType, completion: @escaping ((SessionManager.MultipartFormDataEncodingResult) -> Void)) {
        CHApi.shared.upload(at: .sendMessage, data: data,params: params,mimeType: mimeType){
            encodingResult in
            completion(encodingResult)
        }
    }
    
    
    
    func sendMessage(fileUrl: URL,params: Parameters, completion: @escaping ((SessionManager.MultipartFormDataEncodingResult) -> Void)) {
        CHApi.shared.upload(at: .sendMessage, fileUrl: fileUrl,params: params, mimeType: .Video){
            encodingResult in
            completion(encodingResult)
        }
    }

    
    func sendMessage(params: Parameters, completion: @escaping MessageResult) {
        CHApi.shared.post(at: .sendMessage, params: params).responseObject {
            (res: DataResponse<Message>) in
            completion(res.result.value, res.result.error)
        }
    }
    
    func forwardMessage(params: Parameters, completion: @escaping (Bool) -> ()){
        CHApi.shared.post(at: .forwardMessage, params: params).responseObject{
            (res: DataResponse<Message>) in
            completion(res.result.error == nil)
        }
    }
    
    func deleteMessages(params: Parameters, completion: @escaping StatusResponse) {
        CHApi.shared.post(at: .deleteMessages, params: params).responseJSON {
            (res: DataResponse<Any>) in
            switch res.result{
            case .success( _):
                completion(true,nil)
            case .failure(let error):
                completion(false,error)
            }
        }
    }
    
    func markAllAsRead(chatId: String) {
        CHApi.shared.post(at: .markAllAsRead(chatId:chatId)).responseJSON {
            (res: DataResponse<Any>) in
            if let error = res.result.error{
                debugPrint("Request failed with error: \(error)")
            }
        }
    }
    
    //PUT
    func markAsRead(messageId: String) {
        CHApi.shared.put(at: .markAsRead(messageId: messageId),
                         params: ["userId":Channelize.main.currentUserId()!])
            .responseJSON{(res: DataResponse<Any>) in
                if let error = res.result.error{
                    debugPrint("Request failed with error: \(error)")
                }
        }
    }
    
}
