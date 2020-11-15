//
//  Chat.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 04.11.2020.
//

import UIKit

struct Chat {
    var id: String
    
    var lastMessage: String
    
    var lastMessageTime: String
    
    var chatImage: UIImage
    
    var currentUser: User
    
    var type: ChatType
    
    var isMuted: Bool
}

enum ChatType {
    case privateChat(user: User)
    
    case groupChat(name: String, users: [User])
}
