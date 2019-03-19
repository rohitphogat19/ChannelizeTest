//
//  AlmofireUserService.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class CHUserService: UserService {
    
    //GET
    func getUnreadMessageCount(completion: @escaping (Int, Error?) -> ()){
        
        CHApi.shared.get(at: .unreadMsgCount).responseJSON{
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
    func getUserCount(completion: @escaping (Int, Error?) -> ()) {
        CHApi.shared.get(at: .userCount).responseJSON{
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

    func getUser(id: String, completion: @escaping UserData) {
        CHApi.shared.get(at: .user(id: id)).responseObject {
            (res: DataResponse<User>) in
            completion(res.result.value, res.result.error)
        }
    }
    
    func getContacts(route:ApiRoute, params:Parameters?,completion: @escaping UsersData) {
        CHApi.shared.get(at: route,params: params).responseArray {
            (res: DataResponse<[User]>) in
            completion(res.result.value ?? [], res.result.error)
        }
    }
    
    func getBlockedUsers(completion: @escaping UsersData) {
        CHApi.shared.get(at: .blockedUsers).responseArray {
            (res: DataResponse<[User]>) in
            completion(res.result.value ?? [], res.result.error)
        }
    }
    
    //POST
    
    
    
    func blockUser(userId: String,completion: @escaping (Bool, Error?) -> ()) {
        CHApi.shared.post(at: .blockUser,params: ["userId":userId]).responseJSON {
            (res: DataResponse<Any>) in
            switch res.result{
            case .success( _):
                completion(true,nil)
            case .failure(let error):
                completion(false,error)
            }
        }
    }
    
    func unblockUser(userId: String,completion: @escaping (Bool, Error?) -> ()) {
        CHApi.shared.post(at: .unblockUser,params: ["userId":userId]).responseJSON {
            (res: DataResponse<Any>) in
            switch res.result{
            case .success( _):
                completion(true,nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    //PUT
    func updateUserSettings(params:Parameters?,completion: @escaping UserData) {
        if(Channelize.main.currentUserId() != nil){
            CHApi.shared.put(at: .user(id: Channelize.main.currentUserId()!),params: params).responseObject{
                (res: DataResponse<User>) in
                completion(res.result.value, res.result.error)
            }
        }
    }
    
    //DELETE
    func removeMembers(chatId: String, params: Parameters?, completion: @escaping ChatData) {
        CHApi.shared.post(at: .addMembers(chatId: chatId), params: params)
            .responseObject {(res: DataResponse<Conversation>) in
                completion(res.result.value, res.result.error)
        }
    }
    
}
