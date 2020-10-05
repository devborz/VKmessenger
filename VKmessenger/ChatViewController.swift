//
//  ChatViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 01.10.2020.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, UITextFieldDelegate {
    var chatID: String?
    var userID: String?
    
    let currentUser = Sender(senderId: "self", displayName: "Me")
    let otherUser = Sender(senderId: "other", displayName: "InterLocutor")
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
        setupAttachButton()
        setupSendButton()
        setupInputBar()
        setupColorScheme()
        setupMessagesView()
    }
    
    private func setupColorScheme() {
        view.backgroundColor = UIColor(named: "BackgroundColor")!
        messagesCollectionView.backgroundColor = UIColor(named: "BackgroundColor")!
        messageInputBar.backgroundView.backgroundColor = UIColor(named: "BackgroundColor")!
    }
    
    private func setupMessagesView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.scrollToBottom()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        messagesCollectionView.addGestureRecognizer(tap)
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        }
    }
    
    @objc
    private func hideKeyboard() {
        messageInputBar.inputTextView.resignFirstResponder()
    }
    
    private func setupInputBar() {
        messageInputBar.delegate = self
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.rightStackView.alignment = .center
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.placeholder = "Сообщение"
        messageInputBar.inputTextView.backgroundColor = UIColor(named: "InputViewColor")!
        messageInputBar.inputTextView.layer.cornerCurve = .circular
        messageInputBar.inputTextView.layer.cornerRadius = 15
        messageInputBar.inputTextView.endEditing(true)
    }
    
    private func setupSendButton() {
        messageInputBar.sendButton.image = UIImage(systemName: "arrow.up.circle.fill")
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        messageInputBar.sendButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.contentMode = .scaleAspectFit
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
    }
    
    private func setupAttachButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 40, height: 40), animated: false)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        button.contentMode = .scaleAspectFit
        button.onTouchUpInside { [weak self] _ in
            self?.presentInputActionSheet()
        }
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(sender: currentUser, messageId: "2", sentDate: Date().addingTimeInterval(-86400), kind: .text(text))
        messageInputBar.inputTextView.text = nil
        sendMessage(message)
    }
    
    private func sendMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            self?.messagesCollectionView.scrollToBottom(animated: true)
        })
    }
    
    //    private func isLastSectionVisible() -> Bool {
    //        guard !messages.isEmpty else { return false }
    //
    //        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
    //
    //        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    //    }
    
    private func getMessages() {
        for _ in 1...20 {
            messages.append(Message(sender: otherUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("What's up nigga?")))
        }
        for _ in 1...5 {
            messages.append(Message(sender: currentUser, messageId: "32", sentDate: Date().addingTimeInterval(-86400), kind: .text("What's up\n nigga?")))
        }
    }
}

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
}


