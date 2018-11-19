//
//  TKMessage.swift
//  SocketChat
//
//  Created by quanjunt on 2018/11/19.
//  Copyright © 2018 quanjunt. All rights reserved.
//

import UIKit
import SocketIO



class TKMessage: JSQMessage {
    lazy var avatarImg: JSQMessagesAvatarImage = {
        let avatar = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: senderDisplayName, backgroundColor: UIColor.brown, textColor: UIColor.red, font: UIFont.boldSystemFont(ofSize: 15), diameter: 45)
        return avatar ?? JSQMessagesAvatarImage(placeholder: UIImage())
    }()

}
