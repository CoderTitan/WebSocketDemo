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

    
    init(ID: String, displayName: String, text: String, date: String) {
        senderID = ID
        senderDisplayName = displayName
        dateStr = date
        textStr = text
    }
}
