//
//  MessageProcesser.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 10.10.2020.
//

import Foundation

extension ChatViewController {
    func getMessages() {
        for _ in 1...4 {
            messages.append(Message(sender: otherUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello! How it's going?")))
        }
        for _ in 1...4 {
            messages.append(Message(sender: currentUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello! I'm fine")))
        }
    }
    
    func formatMessage(_ message: String) -> String {
        var text = message
        if text.isEmpty {
            return ""
        }
        while text[text.startIndex] == "\n" || text[text.startIndex] == " " {
            text.remove(at: text.startIndex)
            if text.isEmpty {
                return ""
            }
        }
        func backIndex() -> String.Index {
            return text.index(before: text.endIndex)
        }
        while text[backIndex()] == "\n" || text[backIndex()] == " " {
            text.remove(at: text.index(before: text.endIndex))
            if text.isEmpty {
                return ""
            }
        }
        return text
    }
    
    func sendMessage(_ message: Message) {
        messages.append(message)
        print(messages.count)
        messagesTableView.performBatchUpdates({
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            messagesTableView.insertRows(at: [indexPath], with: .none)
            if messages.count >= 2 {
                let indexPath = IndexPath(row: messages.count - 2, section: 0)
                messagesTableView.reloadRows(at: [indexPath], with: .none)
            }
        }, completion: { [weak self] _ in
            self?.messagesTableView.scrollToLast(true)
        })
    }
}
