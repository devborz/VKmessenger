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
        var sender: User?
        switch chatInfo.type {
        case .privateChat(let otherUser): sender = otherUser
        case .groupChat(_, let otherUsers,_):
            guard otherUsers.count > 0 else { return messages }
            sender = otherUsers.randomElement()
        }
        
        for _ in 1..<2 {
            messages[0].append(Message(sender: sender!, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("Привет! Как дела?")))
        }
        for _ in 1..<2 {
            messages[0].append(Message(sender: chatInfo.currentUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("Привет")))
        }
        for _ in 1..<2 {
            messages[0].append(Message(sender: chatInfo.currentUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("Нормально, а у тебя?")))
        }
        messages[0].append(Message(sender: sender!, messageId: "ghg", sentDate: Date().addingTimeInterval(-86400), kind: .voice))
        messages[0].append(Message(sender: chatInfo.currentUser, messageId: "ghg", sentDate: Date().addingTimeInterval(-86400), kind: .voice))
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd.MM.yyyy"
//        let yesterday = formatter.date(from: "10.10.2000")
//        let message = Message(sender: chatInfo.currentUser, messageId: "hfh", sentDate: yesterday!, kind: .text("Zdarova"))
//        messages[0].append(message)
        
        
        return messages
    }
    
    class var myChats: [Chat] {
        get {
            let chats: [Chat] = [
            Chat(id: "1", lastMessage: Message(sender: User(userId: "id474874848", userName: "Elon Mask",
                                                            avatar: UIImage(named: "Elon")!), messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .text("Как тебе такое?")),
                 currentUser: currentUser, type: .privateChat(user: User(userId: "id474874848", userName: "Elon Mask",
                 avatar: UIImage(named: "Elon")!)), isMuted: false),
            Chat(id: "2", lastMessage: Message(sender: User(userId: "id373975957", userName: "Elon Mask",
                                                            avatar: UIImage(named: "Elon")!), messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .text("Без 'The' круче")),
                currentUser: currentUser, type: .privateChat(user: User(userId: "id373975957", userName: "Mark Zuckerberg",
                avatar: UIImage(named: "Mark")!)), isMuted: false),
            Chat(id: "3", lastMessage: Message(sender: User(userId: "id3484357487", userName: "Ivan Ivanov",
                                                            avatar: UIImage(named: "IU8")!), messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .text("РК Будет")),
                currentUser: currentUser, type: .groupChat(name: "IU8", users: [User(userId: "id3484357487", userName: "Ivan Ivanov",
                avatar: UIImage(named: "IU8")!)], image: UIImage(named: "IU8")!), isMuted: false),
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
        let chat = Chat(id: "id4934893", lastMessage: nil, currentUser: currentUser, type: .privateChat(user: user), isMuted: false)
        myChats.append(chat)
        return chat
    }
}
