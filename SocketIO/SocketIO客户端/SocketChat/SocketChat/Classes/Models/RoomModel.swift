//
//  RoomModel.swift
//  SocketChat
//
//  Created by quanjunt on 2018/11/19.
//  Copyright © 2018 quanjunt. All rights reserved.
//

import UIKit

class RoomModel: NSObject {

    var roomName = ""
    var roomID = ""
    
    init(name: String) {
        roomName = name
        roomID = "\(Int(arc4random() / 100))"
    }
}
