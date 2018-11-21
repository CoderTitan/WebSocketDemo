//
//  ChatViewController.swift
//  SocketChat
//
//  Created by quanjunt on 2018/11/19.
//  Copyright © 2018 quanjunt. All rights reserved.
//

import UIKit

class ChatViewController: JSQMessagesViewController {

    var user = UserModel(name: "")
    
    fileprivate var messageArr = [TKMessage]()
    fileprivate var selfBundle = JSQMessagesBubbleImage(messageBubble: UIImage(), highlightedImage: UIImage())
    fileprivate var otherBundle = JSQMessagesBubbleImage(messageBubble: UIImage(), highlightedImage: UIImage())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputToolbar.contentView.leftBarButtonItem = nil
        
        // 创建气泡
        setupBubble()
        
        // 监听服务器消息发送
        listenServer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 离开房间
        ClientSington.clientSocket.emit("leaveRoom", with: [user.roomName])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputToolbar.inputView?.resignFirstResponder()
    }

    
    /// 创建气泡
    fileprivate func setupBubble() {
        let bundleFactory = JSQMessagesBubbleImageFactory()
        selfBundle = bundleFactory?.outgoingMessagesBubbleImage(with: UIColor.green)
        otherBundle = bundleFactory?.incomingMessagesBubbleImage(with: UIColor.orange)
    }
    
    // 监听服务器消息发送
    fileprivate func listenServer() {
        ClientSington.clientSocket.on("msg") { (data, ack) in
            guard let dicts = data as? [[String: Any]],
                  let dict = dicts.first else { return }
            
            // 获取消息包
            let chunk = TKMessageChunk(dict: dict)
            // 转换成TKMessage
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
            guard let date = fmt.date(from: chunk.dateStr) else { return }
            guard let message = TKMessage(senderId: chunk.senderID, senderDisplayName: chunk.senderDisplayName, date: date, text: chunk.textStr) else { return }
            
            self.messageArr.append(message)
            self.collectionView.reloadData()
            
            // 接受完消息, 让最新的消息显示在最底部
            self.finishReceivingMessage()
        }
    }
}


// MARK:  UICollectionViewDataSource
extension ChatViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageArr.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 消息对象
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as? JSQMessagesCollectionViewCell
        return cell ?? UICollectionViewCell()
    }
}


// MARK: JSQMessagesCollectionViewDataSource
extension ChatViewController {
    // 当前发送者名字:用户
    override var senderDisplayName: String! {
        get {
            return user.userName
        }
        set {}
    }
    
    override var senderId: String! {
        get {
            return user.userID
        }
        set {}
    }

    // 返回每个cell对应消息数据
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let msg = messageArr[indexPath.row]
        return msg
    }
    
    // 返回每个消息的气泡
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        // 消息对象
        let msg = messageArr[indexPath.row]
        if (msg.senderDisplayName ?? "") == user.userName {
            // 自己的消息
            return selfBundle
        }
        
        // 其他人发的消息
        return otherBundle
    }
    
    // 返回每个消息的头像
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        // 消息对象
        let msg = messageArr[indexPath.row]
        
        return msg.avatarImg
    }
    
    // 点击发送的时候调用
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        // 传消息模型给服务器
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dataStr = fmt.string(from: date)
        
        // 发送给服务器
        ClientSington.clientSocket.emit("msg", with: [["senderID": senderId, "dateStr": dataStr, "roomName": user.roomName, "senderDisplayName": senderDisplayName, "text": text]])
        
        // 清空输入文本框
        finishSendingMessage(animated: true)
    }
    
    // 删除消息的时候,就会调用
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didDeleteMessageAt indexPath: IndexPath!) {
        
    }
}
