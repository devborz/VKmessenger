//
//  MessageProcesser.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 10.10.2020.
//

import Foundation

extension ChatViewController {
    func getMessages() {
        for _ in 1...20 {
            messages.append(Message(sender: otherUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("What's up nigga?")))
        }
        for _ in 1...5 {
            messages.append(Message(sender: currentUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("What's up\n nigga?")))
        }
    }
}
