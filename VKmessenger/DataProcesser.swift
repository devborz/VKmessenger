//
//  DataProcesser.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 05.11.2020.
//

import UIKit

class DataProcesser: NSObject {
    class func getMessages(_ chatInfo: Chat) -> [[Message]] {
        var messages = [[Message]]()

        messages.append([Message]())
        messages.append([Message]())
        var sender: User?
        switch chatInfo.type {
        case .privateChat(let otherUser): sender = otherUser
        case .groupChat(_, let otherUsers):
            guard otherUsers.count > 0 else { return messages }
            sender = otherUsers.randomElement()
        }
        
        for _ in 1...40 {
            messages[1].append(Message(sender: sender!, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello! How it's going?")))
        }
        for _ in 1...4 {
            messages[1].append(Message(sender: chatInfo.currentUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello! I'm fine")))
        }
        messages[1].append(Message(sender: sender!, messageId: "ghg", sentDate: Date().addingTimeInterval(-86400), kind: .voice))
        messages[1].append(Message(sender: chatInfo.currentUser, messageId: "ghg", sentDate: Date().addingTimeInterval(-86400), kind: .voice))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let yesterday = formatter.date(from: "10.10.2000")
        let message = Message(sender: chatInfo.currentUser, messageId: "hfh", sentDate: yesterday!, kind: .text("Zdarova"))
        messages[0].append(message)
        
        
        return messages
    }
    
    class var myChats: [Chat] {
        get {
            let chats: [Chat] = [
            Chat(id: "1", lastMessage: "Как тебе такое?", lastMessageTime: "14:20", chatImage: UIImage(named: "Elon")!,
                 currentUser: currentUser, type: .privateChat(user: User(userId: "other", userName: "Elon Mask",
                                                                   avatar: UIImage(named: "Elon")!)), isMuted: false),
            Chat(id: "2", lastMessage: "Перезвони", lastMessageTime: "21:00", chatImage: UIImage(named: "Khabib")!,
                 currentUser: currentUser, type: .privateChat(user: User(userId: "other", userName: "Хабиб Нурмагомедов",
                                                                   avatar: UIImage(named: "Khabib")!)), isMuted: false),
            Chat(id: "3", lastMessage: "Smeesh all these guys", lastMessageTime: "09:00", chatImage: UIImage(named: "Khamzat")!,
                 currentUser: currentUser, type: .groupChat(name: "UFC", users: [User(userId: "other", userName: "Хамзат Чимаев",
                                                                         avatar: UIImage(named: "Khamzat")!)]), isMuted: false),
            ]
            return chats
        }
        set {
            self.myChats = newValue
        }
    }
    
    class var currentUser: User {
        let user = User(userId: "Me", userName: "Me", avatar: UIImage(named: "Elon")!)
        return user
    }
    
    class func getChat(withUser user: User) -> Chat? {
        for chat in myChats {
            switch chat.type {
            case .privateChat(let otherUser):
                if user.userId == otherUser.userId {
                    return chat
                }
            default: continue
            }
        }
        return nil
    }
    
    class func createChat(withUser user: User) -> Chat {
        let chat = Chat(id: "id4934893", lastMessage: "", lastMessageTime: "", chatImage: user.avatar, currentUser: currentUser, type: .privateChat(user: user), isMuted: false)
        myChats.append(chat)
        return chat
    }
}
