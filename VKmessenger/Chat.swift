//
//  Chat.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 04.11.2020.
//

import UIKit

struct Chat {
    var id: String
    
    var lastMessage: Message?
    
    var currentUser: User
    
    var type: ChatType
    
    var isMuted: Bool
    
    var isPinned: Bool = true
    
    var isLastMessageRead: Bool = true
}

enum ChatType {
    case privateChat(user: User)
    
    case groupChat(name: String, users: [User], image: UIImage)
}
