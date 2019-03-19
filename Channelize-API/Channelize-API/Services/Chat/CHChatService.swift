//
//  AlmofireChatService.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class CHChatService: ChatService {
    
    func getEnabledModules(completion: @escaping ModuleData) {
        CHApi.shared.get(at: .getModules).responseArray {
            (res: DataResponse<[Module]>) in
            completion(res.result.value ?? [], res.result.error)
        }
    }
    
    func getRecentChatCount(completion: @escaping CountResponse) {
        let params = ApiFilter.chatCount.filters()
        CHApi.shared.get(at: .chatCount,params: params).responseJSON{
            (res: DataResponse<Any>) in
            switch res.result{
                case .success(let data):
                    let dict = data as! [String:Int]
                    let count = dict["count"]
                    completion(count!,nil)
                case .failure(let error):
                    completion(0,error)
            }
        }
    }
    
    func getGroupsCount(completion: @escaping CountResponse) {
        let params = ApiFilter.groupCount.filters()
        CHApi.shared.get(at: .chatCount,params: params).responseJSON{
            (res: DataResponse<Any>) in
            switch res.result{
            case .success(let data):
                let dict = data as! [String:Int]
                let count = dict["count"]
                completion(count!,nil)
            case .failure(let error):
                completion(0,error)
            }
        }
    }
    
    func getChat(chatId: String, completion: @escaping ChatData) {
        let params = ApiFilter.chat.filters()
        CHApi.shared.get(at: .chat(id: chatId), params:params).responseObject {
            (res: DataResponse<Conversation>) in
            completion(res.result.value, res.result.error)
        }
    }
    
    func getChats(skip:Int,limit:Int, completion: @escaping ChatsData) {
        let params = ApiFilter.recentChats(skip: skip, limit: limit).filters()
        CHApi.shared.get(at: .allChats, params:params).responseArray {
            (res: DataResponse<[Conversation]>) in
            completion(res.result.value ?? [], res.result.error)
        }
    }
    
    func getGroups(skip:Int,limit:Int? = CHConfig.main.pageLimit, completion: @escaping ChatsData) {
        let params = ApiFilter.groups(skip: skip, limit: limit!).filters()
        CHApi.shared.get(at: .allChats, params:params).responseArray {
            (res: DataResponse<[Conversation]>) in
            completion(res.result.value ?? [], res.result.error)
        }
    }
    
    //POST
    func createGroup(params: Parameters, completion: @escaping ChatData) {
        CHApi.shared.post(at: .postNewChat, params: params).responseObject {
            (res: DataResponse<Conversation>) in
            completion(res.result.value, res.result.error)
        }
    }
    
    func changeTitle(chatId:String,params: Parameters, completion: @escaping ChatData) {
        CHApi.shared.post(at: .chageTitle(chatId: chatId), params: params).responseObject {
            (res: DataResponse<Conversation>) in
            completion(res.result.value, res.result.error)
        }
    }
    
    func updateProfile(chatId:String,data: Data, completion: @escaping ChatData) {
        CHApi.shared.upload(at: .updateChat(chatId: chatId), data: data,
                key:"profile", mimeType: .Image){ encodingResult in
                switch encodingResult {
                    case .success( _, _, _):
                        completion(nil,nil)
                    case .failure(let encodingError):
                        completion(nil,encodingError)
            }
        }
    }
    
    func addMembers(chatId: String, params: Parameters?, completion: @escaping ChatData) {
        CHApi.shared.post(at: .addMembers(chatId: chatId), params: params)
            .responseObject {(res: DataResponse<Conversation>) in
                completion(res.result.value, res.result.error)
        }
    }
    
    func removeChatMembers(chatId: String, params: Parameters, completion: @escaping StatusResponse) {
        CHApi.shared.post(at: .removeMembers(chatId: chatId),params: params)
            .responseJSON {
            (res: DataResponse<Any>) in
            switch res.result{
            case .success( _):
                completion(true,nil)
            case .failure(let error):
                completion(false,error)
            }
        }
    }
    
    func leaveChat(chatId: String,completion: @escaping StatusResponse) {
        CHApi.shared.post(at: .leaveChat(chatId: chatId)).responseJSON {
                (res: DataResponse<Any>) in
                switch res.result{
                case .success( _):
                    completion(true,nil)
                case .failure(let error):
                    completion(false,error)
                }
        }
    }
    
    //PUT
    func addGroupAdmin(chatId: String,params:Parameters,completion: @escaping StatusResponse) {
        CHApi.shared.put(at: .makeAdmin(chatId: chatId),params: params).responseJSON {
            (res: DataResponse<Any>) in
            switch res.result{
            case .success( _):
                completion(true,nil)
            case .failure(let error):
                completion(false,error)
                print("Request failed with error: \(error)")
            }
        }
    }
    
    //DELETE
    func clearChat(chatId:String, completion: @escaping StatusResponse) {
        CHApi.shared.delete(at: .clearChat(chatId: chatId)).responseJSON {
            (res: DataResponse<Any>) in
            switch res.result{
            case .success( _):
                completion(true,nil)
            case .failure(let error):
                completion(false,error)
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func deleteChat(chatId:String, completion: @escaping StatusResponse) {
        CHApi.shared.delete(at: .deleteChat(chatId: chatId)).responseJSON {
            (res: DataResponse<Any>) in
            switch res.result{
            case .success( _):
                completion(true,nil)
            case .failure(let error):
                completion(false,error)
                print("Request failed with error: \(error)")
            }
        }
    }
}
