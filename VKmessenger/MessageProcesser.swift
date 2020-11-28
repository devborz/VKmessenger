//
//  MessageProcesser.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 10.10.2020.
//

import Foundation

class MessageProccesser {
    
    class func formatMessage(_ message: String) -> String {
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
}
