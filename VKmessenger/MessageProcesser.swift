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
        messagesTableView.performBatchUpdates({
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            messagesTableView.insertRows(at: [indexPath], with: .automatic)
            if messages.count >= 2 {
                let indexPath = IndexPath(row: messages.count - 2, section: 0)
                messagesTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }, completion: { [weak self] _ in
            self?.messagesTableView.scrollToLast()
        })
    }
}