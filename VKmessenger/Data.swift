//
//  Data.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 04.11.2020.
//

import Foundation

class Data {
    class func getMessages(_ chatInfo: Chat) -> [Message] {
        var messages = [Message]()
        for _ in 1...40 {
            messages.append(Message(sender: chatInfo.otherUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello! How it's going?")))
        }
        for _ in 1...4 {
            messages.append(Message(sender: chatInfo.currentUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello! I'm fine")))
        }
        return messages
    }
}
