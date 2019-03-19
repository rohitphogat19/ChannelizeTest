//
//  CHSession.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import Foundation
import MQTTClient

class CHSession: NSObject, MQTTSessionDelegate{

    private let port: UInt32 = 0 //1884 for local & 0 for remote
    private var session: MQTTSession!
    var isConnected:Bool = false
    
    internal var contactDelegates = [UUID:CHUserEventDelegate]()
    internal var convDataDelegates = [UUID:CHConversationDataDelegate]()
    var deleteMsgTopics = [String]()
    
    static var shared: CHSession = {
        let sessionManager = CHSession()
        return sessionManager
    }()
    
    
    private override init() {
        self.session = MQTTSession.init()
    }
    
    func connect(){
        debugPrint("Session Connecting")
        let scTransport = MQTTWebsocketTransport.init()
        scTransport.host = Channelize.main.host()
        scTransport.tls = true
        scTransport.port = port
        session?.userName = Channelize.main.currentUserId()
        session?.delegate = self
        session?.transport = scTransport
        
        let willMessage = try! JSONSerialization.data(withJSONObject: ["userId":Channelize.main.currentUserId()!],options: .prettyPrinted)
        
        session.willFlag = true
        session.willTopic = "server/users/offline"
        session.willMsg = willMessage
        
        session?.connect()
        
        MQTTLog.setLogLevel(.off)
        
    }
    
    func disconnectServer(){
        debugPrint("Disconnecting From Server")
        session?.disconnect()
    }
    
    func clearSession(){
        debugPrint("Clearing Session")
        session?.disconnect()
        deleteMsgTopics.removeAll()
    }
    
    func reconnect(){
        debugPrint("Session Reconnecting")
        session?.connect()
    }
    
    func connected(_ session: MQTTSession!) {
        debugPrint("Session Connected")
        self.isConnected = true
        self.session = session
        subscribeAllTopics()
    }
    
    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        self.newDataReceived(topic: topic, data: data)
    }
    
    func connectionClosed(_ session: MQTTSession!) {
        debugPrint("Session Closed")
        self.isConnected = false
        self.session.connect()
//        if Channelize.main.currentUserId() != nil {
//            
//        }
    }
    
    func connectionError(_ session: MQTTSession!, error: Error!) {
        print("Error in connection - ", error)
    }
    
    func subscribeTo(topic: String){
        self.session.subscribe(toTopic: topic, at: .atMostOnce){ error,qos in
            if let error = error {
                return print(error.localizedDescription)
            }
            debugPrint("Topic Subscribed - ",topic)
        }
    }
    
    func unsubscribeTo(topic: String){
        session.unsubscribeTopics([topic])
        debugPrint("UnSubscribing - ",topic)
    }
    
    func subscribeAllTopics(){
        for subscriber in Subscriber.all{
            subscribeTo(topic: subscriber.value())
        }
        
        for deleteTopic in deleteMsgTopics{
            subscribeTo(topic: deleteTopic)
        }
    }
    
    func publish(data:[String:Any],topic:String){
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            self.session.publishData(atMostOnce: jsonData, onTopic: topic)
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func removeDelegate(`for` delegateId:UUID){
        convDataDelegates.removeValue(forKey: delegateId)
    }
    
    func removeTopic(topic:String?){
        if let topic = topic {
            unsubscribeTo(topic: topic)
            if let index = deleteMsgTopics.index(where:{(intopic) -> Bool in
                intopic == topic }){
                deleteMsgTopics.remove(at: index)
            }
        }
    }
}
