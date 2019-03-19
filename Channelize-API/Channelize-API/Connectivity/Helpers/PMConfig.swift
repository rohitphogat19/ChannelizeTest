//
//  CHConfig.swift
//  Channelize
//
//  Created by Ashish on 12/31/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import Foundation

class CHConfig{
    
    public var pageLimit = 30
    
    static var main: CHConfig = {
        let config = CHConfig()
        return config
    }()
    
}
