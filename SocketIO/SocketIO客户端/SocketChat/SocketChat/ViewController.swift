//
//  ViewController.swift
//  SocketChat
//
//  Created by quanjunt on 2018/11/15.
//  Copyright © 2018 quanjunt. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {

//    fileprivate var socket: SocketIOClient?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: "ws://localhost:9090") else { return }
        let manager = SocketManager(socketURL: url, config: nil)
        let socket = manager.defaultSocket
        
        // 建立链接
        socket.connect()
        
        // 监听是否链接成功, 建立连接成功, 服务器也会给客户端发送
        socket.on(clientEvent: .connect) { (data, ack) in
            print("链接成功")
            
            // 向服务器发送chat时间, 发送数据
            socket.emit("chat", with: ["hello", "world"])
        }
        
        socket.on("chat") { (data, ack) in
            print(data)
        }
        
        
        
    }


}

