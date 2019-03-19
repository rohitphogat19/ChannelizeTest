//
//  CHConnectionDelegate.swift
//  Channelize-API
//
//  Created by Ashish-BigStep on 1/24/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation

public protocol CHConnectionDelegate {
    func didStartReconnection()
    
    func didServerConnected()
    
    func didServerDisconnected()
    
    func didConnectionFailed()
}
