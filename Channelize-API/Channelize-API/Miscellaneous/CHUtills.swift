//
//  CHUtills.swift
//  Channelize-API
//
//  Created by Ashish-BigStep on 1/17/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation

func CHLocalized(key: String) -> String{
    let s =  NSLocalizedString(key, tableName: "CHLocalizable", bundle: Bundle.main, value: "", comment: "")
    return s
}
