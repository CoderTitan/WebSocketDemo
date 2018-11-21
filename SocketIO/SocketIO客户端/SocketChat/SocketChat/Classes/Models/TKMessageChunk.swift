//
//  TKMessageChunk.swift
//  SocketChat
//
//  Created by quanjunt on 2018/11/19.
//  Copyright © 2018 quanjunt. All rights reserved.
//

import UIKit

class TKMessageChunk: NSObject {
    
    var senderID = ""
    var senderDisplayName = ""
    var dateStr = ""
    var textStr = ""
    var roomName = ""

    
    
    
    init(dict: [String: Any]) {
        senderID = dict["senderId"] as? String ?? ""
        senderDisplayName = dict["senderDisplayName"] as? String ?? ""
        dateStr = dict["dateStr"] as? String ?? ""
        textStr = dict["text"] as? String ?? ""
        roomName = dict["roomName"] as? String ?? ""
    }
}
