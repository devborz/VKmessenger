//
//  DataManager.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 05.11.2020.
//

import UIKit

class DataManager: NSObject {
    
    func getChatsForFolder(_ folderName: String) -> [Chat] {
        var folderChats = [Chat]()
        switch folderName {
        case "Все": folderChats = myChats
        case "Работа":
            let chatIDs = ["1"]
            for chat in myChats {
                if chatIDs.contains(chat.id) {
                    folderChats.append(chat)
                }
            }
        case "Личные":
            let chatIDs = ["2", "3"]
            for chat in myChats {
                if chatIDs.contains(chat.id) {
                    folderChats.append(chat)
                }
            }
        default: folderChats = []
        }
        return folderChats
    }
    
    func removeChatWithID(_ id: String) {
        for i in 0..<myChats.count {
            if myChats[i].id == id {
                myChats.remove(at: i)
                break
            }
        }
    }
    
    func muteChatWithID(_ id: String) {
        for i in 0..<myChats.count {
            if myChats[i].id == id {
                myChats[i].isMuted = !myChats[i].isMuted
                break
            }
        }
    }
    
    func getMessages(_ chatInfo: Chat) -> [[Message]] {
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
            messages[0].append(Message(sender: sender!, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .standart(text: "Привет! Как дела?", attachedItems: nil, messageToReply: nil), type: .incoming, state: .read))
        }
        for _ in 1..<2 {
            messages[0].append(Message(sender: chatInfo.currentUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .standart(text: "Привет!", attachedItems: nil, messageToReply: nil), type: .outgoing, state: .read))
        }
        messages[0].append(Message(sender: sender!, messageId: "ghg", sentDate: Date().addingTimeInterval(-86400), kind: .voice(messageToReply: nil), type: .incoming, state: .read))
        messages[0].append(Message(sender: chatInfo.currentUser, messageId: "ghg", sentDate: Date().addingTimeInterval(-86400), kind: .voice(messageToReply: nil), type: .outgoing, state: .read))
        
        
        return messages
    }
    
    var myChats: [Chat] = {
        let chats: [Chat] = [
        Chat(id: "1", lastMessage: Message(sender: User(userId: "id474874848", userName: "Elon Musk",
                                                        avatar: UIImage(named: "Elon")!), messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .standart(text: "Как тебе такое?", attachedItems: nil, messageToReply: nil), type: .incoming, state: .unread),
             currentUser: currentUser(), type: .privateChat(user: User(userId: "id474874848", userName: "Elon Musk",
             avatar: UIImage(named: "Elon")!)), isMuted: false),
        Chat(id: "2", lastMessage: Message(sender: User(userId: "id373975957", userName: "Elon Mask",
                                                        avatar: UIImage(named: "Mark")!), messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .standart(text: "Без 'The' круче", attachedItems: nil, messageToReply: nil), type: .incoming, state: .unread),
             currentUser: currentUser(), type: .privateChat(user: User(userId: "id373975957", userName: "Mark Zuckerberg",
            avatar: UIImage(named: "Mark")!)), isMuted: false),
        Chat(id: "3", lastMessage: Message(sender: User(userId: "id3484357487", userName: "Ivan Ivanov",
                                                        avatar: UIImage(named: "IU8")!), messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .standart(text: "РК Будет", attachedItems: nil, messageToReply: nil), type: .incoming, state: .unread),
            currentUser: currentUser(), type: .groupChat(name: "IU8", users: [User(userId: "id3484357487", userName: "Ivan Ivanov",
            avatar: UIImage(named: "IU8")!)], image: UIImage(named: "IU8")!), isMuted: false),
        ]
        return chats
    }()

    
    class func currentUser() -> User {
        let user = User(userId: "Me", userName: "Me", avatar: UIImage(named: "Elon")!)
        return user
    }
    
    func getChat(withUser user: User) -> Chat? {
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
    
    func createChat(withUser user: User) -> Chat {
        let chat = Chat(id: "id4934893", lastMessage: nil, currentUser: DataManager.currentUser(), type: .privateChat(user: user), isMuted: false)
        myChats.append(chat)
        return chat
    }
}
