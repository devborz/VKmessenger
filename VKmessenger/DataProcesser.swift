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
        
        for _ in 1...40 {
            messages[1].append(Message(sender: chatInfo.otherUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello! How it's going?")))
        }
        for _ in 1...4 {
            messages[1].append(Message(sender: chatInfo.currentUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello! I'm fine")))
        }
        messages[1].append(Message(sender: chatInfo.otherUser, messageId: "ghg", sentDate: Date().addingTimeInterval(-86400), kind: .voice))
        messages[1].append(Message(sender: chatInfo.currentUser, messageId: "ghg", sentDate: Date().addingTimeInterval(-86400), kind: .voice))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let yesterday = formatter.date(from: "10.10.2000")
        let message = Message(sender: chatInfo.currentUser, messageId: "hfh", sentDate: yesterday!, kind: .text("Zdarova"))
        messages[0].append(message)
        
        
        return messages
    }
}
