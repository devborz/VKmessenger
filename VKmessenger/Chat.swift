//
//  Chat.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 04.11.2020.
//

import UIKit

struct Chat {
    var id: String
    
    var name: String
    
    var lastMessage: String
    
    var lastMessageTime: String
    
    var chatImage: UIImage
    
    var currentUser: User
    
    var otherUser: User
}

enum ChatType {
    case privateChat
    case group
}
