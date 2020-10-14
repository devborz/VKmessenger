//
//  MessageProtocols.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 10.10.2020.
//

import UIKit
import MessageKit

// MARK: MessagesDataSources & MessageCellDelegate

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate {
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = messages[indexPath.section].sender.senderId
        switch sender {
        case currentUser.senderId:
            avatarView.image = UIImage(systemName: "person")
        default:
            avatarView.image = UIImage(systemName: "person.fill")
            avatarView.backgroundColor = .white
        }
    }
}

extension ChatViewController: MessagesDisplayDelegate, MessageCellDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender.senderId
        switch sender {
        case currentUser.senderId:
            return UIColor(named: "CurrentUserMessageBackgroundColor")!
        default:
            return UIColor(named: "OtherUserMessageBackgroundColor")!
        }
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor(named: "TextColor")!
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: message.sentDate)
        let minute = calendar.component(.minute, from: message.sentDate)
        let hourDesc = hour.description.count < 2 ? "0\(hour)" : "\(hour)"
        let minuteDesc = minute.description.count < 2 ? "0\(minute)" : "\(minute)"
        
        let paragraphStyle = NSMutableParagraphStyle()
        switch message.sender.senderId {
        case currentUser.senderId: paragraphStyle.alignment = .right
        default: paragraphStyle.alignment = .left
        }
        
        let timestamp = NSAttributedString(string: "\(hourDesc):\(minuteDesc)", attributes:
                                    [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                                     NSAttributedString.Key.foregroundColor : UIColor.systemGray,
                                     NSAttributedString.Key.paragraphStyle : paragraphStyle])
        return timestamp
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 12
    }
}
