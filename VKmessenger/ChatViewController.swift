//
//  ChatViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 01.10.2020.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import BTNavigationDropdownMenu

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

struct ChatMenuOption {
    var name: String
    var image: UIImage
    var action: (()->Void)?
}

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, UITextFieldDelegate {
    var chatID: String?
    var userID: String?
    
    let currentUser = Sender(senderId: "self", displayName: "Me")
    let otherUser = Sender(senderId: "other", displayName: "InterLocutor")
    var messages = [Message]()
    
    var chatMenuOptions: [ChatMenuOption] = [
        ChatMenuOption(name: "Открыть профиль", image: UIImage(systemName: "person.crop.circle")!, action: nil),
        ChatMenuOption(name: "Добавить в беседу", image: UIImage(systemName: "plus.message")!, action: nil),
        ChatMenuOption(name: "Поиск сообщений", image: UIImage(systemName: "magnifyingglass")!, action: nil),
        ChatMenuOption(name: "Показать вложения", image: UIImage(systemName: "photo")!, action: nil),
        ChatMenuOption(name: "Отключить уведомления", image: UIImage(systemName: "volume.slash")!, action: nil),
        ChatMenuOption(name: "Очистить историю", image: UIImage(systemName: "trash")!, action: nil),
    ]
    
    @IBOutlet var transparentView: UIView!
    
    @IBOutlet var inputBarTransparentView: UIView!
    
    @IBOutlet weak var dropdownMenuTable: UITableView!
    
    @IBOutlet var dropdownMenu: UIView!
    
    var dropdownMenuHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var titleButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messagesCollectionView.scrollToBottom(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
        setupAttachButton()
        setupSendButton()
        setupInputBar()
        setupColorScheme()
        setupMessagesView()
        setupNavigationBar()
        setupDropDownMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        
        additionalBottomInset = 20
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
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.layer.borderWidth = 0
        navigationController?.navigationBar.layoutIfNeeded()
        navigationController?.navigationBar.backgroundColor = UIColor(named: "BackgroundColor")
        titleButton.setTitle(self.title, for: .normal)
    }
    
    
    @IBAction func pressedTitleButton(_ sender: Any) {
        if titleButton.isSelected {
            hideChatMenu()
        } else {
            showChatMenu()
        }
    }
}

