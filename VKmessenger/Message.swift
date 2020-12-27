//
//  Message.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 04.11.2020.
//

import UIKit
import MapKit
import AVKit

struct Message {
    var sender: User
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var type: MessageType
    var state: MessageState
}

indirect enum MessageKind {
    case standart(text: String, attachedItems: [AttachedItem]?, messageToReply: AttachedItem?)
    case voice(messageToReply: AttachedItem?)
}

enum MessageType {
    case outgoing
    case incoming
}

enum MessageState {
    case read
    case unread
}

enum AttachedItem {
    case Image(image: UIImage)
    case Video(media: Media)
    case Document(document: Document)
    case Location(coordinate: CLLocationCoordinate2D)
    case Message(message: Message)
}

struct Media {
    var url: URL
    var thumbnail: UIImage
    var duration: CMTime
}

struct Document {
    var url: URL
    var name: String
    var type: String
    var size: Int64
}

struct Image {
    var image: UIImage
    var url: URL?
}
