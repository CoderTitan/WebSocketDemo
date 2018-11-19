//
//  UserModel.swift
//  SocketChat
//
//  Created by quanjunt on 2018/11/19.
//  Copyright © 2018 quanjunt. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    var userName = ""
    var userID = ""
    var roomName = ""
    
    init(name: String) {
        userName = name
        userID = "\(Int(arc4random() / 1000 + arc4random() / 200 + arc4random() / 300))"
    }
}
