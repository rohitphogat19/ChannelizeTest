//
//  Channelize.swift
//  Channelize-API
//
//  Created by Apple on 12/27/18.
//  Copyright © 2018 Channelize. All rights reserved.
//

import Foundation

open class Channelize{
    
    fileprivate static var chFCMToken:String?
    fileprivate var apiUrl: String?
    fileprivate var defaultHost: String?
    fileprivate var apiKey: String?
    
    fileprivate var userEmail: String?
    fileprivate var selfUserId: String?
    
    open static var main: Channelize = {
        let channelize = Channelize()
        return channelize
    }()
    
    public static func configure(){
        if let path = Bundle.main.path(forResource: "Channelize-Info-demo", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                Channelize.main.defaultHost = dict["MQTT_URL"] as? String
                Channelize.main.apiKey = dict["PUBLIC_KEY"] as? String
                Channelize.main.apiUrl = dict["API_URL"] as? String
            }
        }
    }
    
    open func login(username:String,password:String, completion: @escaping UserData){
        let params:[String:Any] = ["email":username,
                                   "password":password]
                                   //"authenticationType":1]
        
        CHApi.shared.login(params,completion: {(user,error) in
            if error != nil {
                completion(nil,error)
            } else {
                self.selfUserId = user?.id
                if (Channelize.chFCMToken != nil) {
                    Channelize.updateToken(token: Channelize.chFCMToken!)
                }
                completion(user,nil)
            }
        })
    }
    
    open func login(userId:String,accessToken:String, completion: @escaping UserData){
        let params:[String:Any] = ["userId":userId,
                                   "pmClientServerToken":accessToken,
                                   "authenticationType":0]
        CHApi.shared.login(params,completion: {(user,error) in
            if error != nil {
                completion(nil,error)
            } else {
                self.selfUserId = user?.id
                if (Channelize.chFCMToken != nil) {
                    Channelize.updateToken(token: Channelize.chFCMToken!)
                }
                completion(user,nil)
            }
        })
    }
    
    public static func connect(){
        CHSession.shared.connect()
    }
    
    open static func updateToken(token:String){
        chFCMToken = token
        if(Channelize.main.currentUserId() != nil){
            CHApi.shared.updateToken(token: token)
        }
        
    }
    
    open static func deleteToken(){
        if(Channelize.main.currentUserId() != nil) {
            CHApi.shared.deleteToken()
        }
    }
    
    open static func updateUserStatus(isOnline:Bool,completion: @escaping UserData){
        CHService.main.userService.updateUserSettings(params: ["isOnline":isOnline], completion: completion)
    }
    
    open static func updateUserSettings(params: [String:Any],completion: @escaping UserData){
        CHService.main.userService.updateUserSettings(params: params, completion: completion)
    }
        
    public static func disconnect(){
        CHSession.shared.disconnectServer()
        //CHSession.shared.clearSession()
    }
    
    open func logout(){
        CHApi.shared.deleteToken()
    }
}

//Getters
extension Channelize {
    
    func host()->String{
        return defaultHost ?? ""
    }
    
    func key() -> String {
        return apiKey ?? ""
    }
    
    func apiPath()-> String{
        return apiUrl ?? ""
    }
    
    public func currentUserName() -> String?{
        return UserDefaults.standard.object(forKey: UserKey.Name.key()) as? String
    }
    
    public func currentUserId() -> String?{
        return UserDefaults.standard.object(forKey: UserKey.ID.key()) as? String
    }
    
    internal func getAccessToken() -> String? {
        return UserDefaults.standard.object(forKey: UserKey.AccessToken.key()) as? String
    }
}

extension Channelize {
    public static func addConversationDelegate(_ delegate:CHConversationDataDelegate,
                                               identifier:UUID){
        CHSession.shared.convDataDelegates.updateValue(delegate, forKey: identifier)
    }
    public static func addUserDelegate(_ delegate:CHUserEventDelegate, identifier:UUID){
        CHSession.shared.contactDelegates.updateValue(delegate, forKey: identifier)
    }
    
    public static func addConnectionDelegate(_ delegate:CHConnectionDelegate, identifier: UUID){
        
    }
    public static func removeDelegate(with identifier:UUID){
        CHSession.shared.contactDelegates.removeValue(forKey: identifier)
        CHSession.shared.convDataDelegates.removeValue(forKey: identifier)
    }
}
