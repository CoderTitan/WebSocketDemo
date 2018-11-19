//
//  ClientSington.swift
//  SocketChat
//
//  Created by quanjunt on 2018/11/19.
//  Copyright © 2018 quanjunt. All rights reserved.
//

import UIKit
import SocketIO

class ClientSington {

    static var socketManger: SocketManager = {
        let url = URL(string: "ws://192.168.2.39:8080")
        return SocketManager(socketURL: url!, config: [])
    }()
    
    static var clientSocket = socketManger.defaultSocket
    
}
