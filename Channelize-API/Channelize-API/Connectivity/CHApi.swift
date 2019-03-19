//
//  CHApi.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//
import Foundation
import Alamofire
import ObjectMapper

typealias LoginHandler = (_ chat: CHUser?, _ error: Error?) -> ()

enum CHMimeType:String {
    case Image = "image/jpeg"
    case Video = "video/mp4"
    case Audio = "audio/m4a"
}

class CHApi {
    
    var isReachable:Bool = false
    
    static var shared: CHApi = {
        let sessionManager = CHApi()
        return sessionManager
    }()
    
    private init() {}
    
    private func getAccessToken() -> String? {
        if let token = Channelize.main.getAccessToken() {
            let data = token.data(using: String.Encoding.utf8)
            let finalKey = data?.base64EncodedString()
            return "Bearer \(finalKey!)"
        }
        return nil
    }
    
    func getHeaders() -> HTTPHeaders {
        let data = Channelize.main.key().data(using: String.Encoding.utf8)
        let finalKey = data?.base64EncodedString()
        return ["authorization":"Basic \(finalKey!)"]
        //return "Basic \(finalKey!)"
    }
    
    func getHeaders2() -> HTTPHeaders {
        if let authorizationToken = getAccessToken(){
            return ["Authorization":authorizationToken,
                    "Public-Key":Channelize.main.key()]
        }
        return ["Public-Key":Channelize.main.key()]
    }
    
    private func updateUser(user: CHUser?, token:String?){
        let defaults =  UserDefaults.standard
        defaults.set(user?.id, forKey: UserKey.ID.key())
        defaults.set(user?.uVisibility, forKey: UserKey.Visibility.key())
        defaults.set(user?.language, forKey: UserKey.Language.key())
        defaults.set(user?.notification, forKey: UserKey.Notification.key())
        defaults.set(user?.displayName, forKey: UserKey.Name.key())
        defaults.set(user?.profileImageUrl, forKey: UserKey.Image.key())
        defaults.set(token, forKey: UserKey.AccessToken.key())
    }
    
    func login(_ params:Parameters,completion: @escaping LoginHandler){
        post(at: .login,params: params).responseData{ [weak self]
            (data: DataResponse<Data>) in
            switch data.result{
            case .success( _):
                do {
                    let dict =  try JSONSerialization.jsonObject(with: data.result.value!, options: [])
                        as! [String: Any]
                    let token = dict["id"] as? String
                    let user = Mapper<User>().map(JSONObject: dict["user"])
                    self?.updateUser(user: user,token:token)
                    completion(user,nil)
                } catch {
                    debugPrint("Login Data Invalid - ",error)
                    completion(nil,error)
                }
            case .failure(let error):
                debugPrint("Login Failed With - ",error)
                completion(nil,error)
            }
        }
    }
    
    func updateToken(token:String){
        let params:Parameters = ["deviceId":UIDevice.current.identifierForVendor!.uuidString,
                                 "token":token]
        self.post(at: .fcmToken,params: params).responseData{(data: DataResponse<Data>) in
            switch data.result{
            case .success( _):
                debugPrint("Request success - Token Updated")
            case .failure(let error):
                debugPrint("Request failed with error: \(error)")
            }
        }
        
    }
    
    func deleteToken(){
        let params:Parameters = ["deviceId":UIDevice.current.identifierForVendor!.uuidString]
        self.delete(at: .fcmToken,params: params).responseData{(data: DataResponse<Data>) in
            switch data.result{
            case .success( _):
                debugPrint("Request success - Token deleted")
            case .failure(let error):
                debugPrint("Request failed with error: \(error)")
            }
            UserDefaults.standard.removeObject(forKey: UserKey.ID.key())
        }
    }
    
    func get(at route: ApiRoute, params: Parameters? = nil) -> DataRequest {
        return request(
            at: route,
            method: .get,
            params: params,
            encoding: URLEncoding.queryString)
    }
    
    func post(at route: ApiRoute, params: Parameters? = nil) -> DataRequest {
        return request(
            at: route,
            method: .post,
            params: params,
            encoding: JSONEncoding.default)
    }
    
    func put(at route: ApiRoute, params: Parameters? = nil) -> DataRequest {
        return request(
            at: route,
            method: .put,
            params: params,
            encoding: JSONEncoding.default)
    }
    
    func delete(at route: ApiRoute, params: Parameters? = nil) -> DataRequest {
        return request(
            at: route,
            method: .delete,
            params: params,
            encoding: JSONEncoding.default)
    }
    
    func request(at route: ApiRoute, method: HTTPMethod, params: Parameters?, encoding: ParameterEncoding) -> DataRequest {
        let url = route.url()
        return Alamofire.request(
            url,
            method: method,
            parameters: params,
            encoding: encoding,
            headers:getHeaders())
            .validate()
    }
    
    func upload(at route:ApiRoute, data:Data? = nil, fileUrl:URL? = nil,
                params: Parameters? = nil, key:String? = "file",mimeType:CHMimeType,
                completion: @escaping((SessionManager.MultipartFormDataEncodingResult) -> Void)){
        // Use Alamofire to upload the image
        Alamofire.upload(multipartFormData: { multipartFormData in
            let imageName = UUID().uuidString
            if let data = data{
                multipartFormData.append(data, withName: key!, fileName: imageName+".jpeg",
                                     mimeType: mimeType.rawValue)
            }
            if let url = fileUrl{
                multipartFormData.append(url, withName: key!, fileName: imageName+".mp4",
                                         mimeType: mimeType.rawValue)
            }
            if let parameter = params{
                for (key, value) in parameter {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!,
                                             withName: key as String)
                }
            }
            
        },to: route.url(),headers:getHeaders(), encodingCompletion: { encodingResult in
            completion(encodingResult)
        })
    }
   
}
