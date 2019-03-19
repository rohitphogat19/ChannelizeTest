//
//  MessageService.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//
import Alamofire

public typealias UploadProgress = (_ progess : Double) -> ()
public typealias ModuleData = (_ modules: [CHModule], _ error: Error?) -> ()
public typealias MessageResult = (_ message: CHMessage?, _ error: Error?) -> ()
public typealias MessagesData = (_ messages: [CHMessage], _ error: Error?) -> ()

protocol MessageService{
    
    func getMessageCount(chatId: String, completion: @escaping CountResponse)
    func getMessage(id: String, completion: @escaping MessageResult)
    func getMessages(chatId: String,params:Parameters,completion: @escaping MessagesData)
    func getCustomMessages(chatId: String,params:Parameters,completion: @escaping MessagesData)
    func fetchChat(recipientId:String,completion: @escaping ChatData)
    func getChat(chatId:String,completion: @escaping ChatData)
    
    //POST
    func sendMessage(data: Data,params: Parameters,mimeType:CHMimeType, completion: @escaping ((SessionManager.MultipartFormDataEncodingResult) -> Void))
    func sendMessage(data:Data,params:Parameters, completion: @escaping  ((SessionManager.MultipartFormDataEncodingResult) -> Void))
    func sendMessage(fileUrl:URL, params:Parameters, completion: @escaping  ((SessionManager.MultipartFormDataEncodingResult) -> Void))
    func sendMessage(params: Parameters, completion: @escaping MessageResult)
    func markAllAsRead(chatId:String)
    
    //PUT
    func markAsRead(messageId:String)
    
    //delete
    func deleteMessages(params: Parameters,completion: @escaping StatusResponse)
    
}
