//
//  model.swift
//  simpleChating
//
//  Created by iosdev on 9/30/17.
//  Copyright © 2017 iosdev. All rights reserved.
//

import Foundation

internal class Channel{
    internal let id: String
    internal let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
