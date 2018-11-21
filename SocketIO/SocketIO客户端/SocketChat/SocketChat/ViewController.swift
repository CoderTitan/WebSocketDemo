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

    @IBOutlet weak var nameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameText.resignFirstResponder()
    }
}


extension ViewController {
    @IBAction func jumpChatController(_ sender: UIButton) {
        // 创建房间模型
        let roomNme = "房间" + "\(sender.tag)"
        let roomModel = RoomModel(name: roomNme)
        
        // 向服务器发送请求, x创建爱你房间
        ClientSington.clientSocket.emit("joinRoom", with: [["roomID": roomModel.roomID, "roomName": roomModel.roomName]])
        
        // 创建用户
        let user = UserModel(name: nameText.text ?? "")
        user.roomName = roomModel.roomName
        
        let vc = ChatViewController()
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
}
