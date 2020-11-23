//
//  MessageProcesser.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 10.10.2020.
//

import Foundation

extension ChatViewController {
    
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
        if messages.count == 0 {
            messages.append([Message]())
            messagesTableView.reloadData()
        }
        
        messages[0].append(message)
        messagesTableView.performBatchUpdates({
            let indexPath = IndexPath(row: messages[0].count - 1, section: 0)
            messagesTableView.insertRows(at: [indexPath], with: .none)
            if messages.count >= 2 {
                let indexPath = IndexPath(row: messages[0].count - 2, section: 0)
                messagesTableView.reloadRows(at: [indexPath], with: .none)
            }
        }, completion: { [weak self] _ in
            self?.messagesTableView.scrollToLast(true)
        })
    }
}
