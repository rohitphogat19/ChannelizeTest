//
//  File.swift
//  Channelize-API
//
//  Created by Apple on 1/5/19.
//  Copyright © 2019 Channelize. All rights reserved.
//

import Foundation

public protocol CHFile {
    
    var id: String! { get }
    var fileUrl: String? { get }
    var name: String? { get }
    var thumbnailUrl: String? { get }
    var attachmentType: String? { get }
    var duration:Double? { get }
}
