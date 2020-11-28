//
//  Message.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 04.11.2020.
//

import UIKit
import AVKit

struct Message {
    var sender: User
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

enum MessageKind {
    case text(String)
    case image(UIImage)
    case voice
}

enum AttachedItem {
    case Image(UIImage)
    case Video(Media)
    case Music
    case Document
    case Locaion
}
