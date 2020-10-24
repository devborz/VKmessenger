//
//  ChatViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 01.10.2020.
//

import UIKit

enum MessageKind {
    case text(String)
    case image(UIImage)
}

struct Sender {
    var senderId: String
    var displayName: String
}

struct Message {
    var sender: Sender
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Media {
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

class ChatViewController: UIViewController {
    var chatID: String?
    var userID: String?
    
    let currentUser = Sender(senderId: "self", displayName: "Me")
    let otherUser = Sender(senderId: "other", displayName: "InterLocutor")
    var messages = [Message]()
    
    @IBOutlet var transparentView: UIView!
    
    @IBOutlet weak var dropdownMenuTableView: UITableView!
    
    @IBOutlet var dropdownMenu: UIView!
    
    var dropdownMenuHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var titleButton: UIButton!
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    @IBOutlet weak var messageInputBar: UIView!
    
    var messageInputBarBottomConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var inputTextView: UITextView!
    
    @IBOutlet weak var inputBar: UIView!
    
    @IBOutlet weak var attachButton: UIButton!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var didFirstLayoutOfSubviews = false
    
    var keyboardIsShown = false
    
    var shouldScrollToLastRow = true
    
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
        setupKeyBoardObservers()
        shouldScrollToLastRow = true;
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Scroll table view to the last row
        if shouldScrollToLastRow {
            shouldScrollToLastRow = false;
            messagesTableView.scrollToLast(false)
        }
    }
    
    private func setupColorScheme() {
        view.backgroundColor = UIColor(named: "BackgroundColor")!
        messagesTableView.backgroundColor = UIColor(named: "BackgroundColor")!
        messageInputBar.backgroundColor = UIColor(named: "BackgroundColor")!
    }
    
    private func setupMessagesView() {
        messagesTableView.register(UINib(nibName: "OutgoingMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "OutgoingMessageCell")
        messagesTableView.register(UINib(nibName: "IncomingMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomingMessageCell")
        
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        messagesTableView.addGestureRecognizer(tap)
        
        messagesTableView.separatorStyle = .none
    }
    
    @objc private func hideKeyboard() {
        inputTextView.resignFirstResponder()
    }
    
    private func setupInputBar() {
        inputBar.layer.cornerRadius = 17
        inputBar.layer.borderWidth = 0
        inputBar.clipsToBounds = true
        inputBar.layer.masksToBounds = true
        inputTextView.delegate = self
        inputTextView.textColor = .lightGray
        inputTextView.endEditing(true)
    }
    
    private func setupSendButton() {
        sendButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        sendButton.setTitle(nil, for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        sendButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        sendButton.contentMode = .scaleAspectFit
        sendButton.isEnabled = false
    }
    
    private func setupAttachButton() {
        attachButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        attachButton.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        attachButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        attachButton.contentMode = .scaleAspectFit
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
    
    private func setupKeyBoardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(notification: NSNotification) {
        if !keyboardIsShown {
            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            if let frame = keyboardFrame, let duration = animationDuration {
                messageInputBarBottomConstraint?.isActive = false
                messageInputBarBottomConstraint = messageInputBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -frame.height + 40)
                NSLayoutConstraint.activate([messageInputBarBottomConstraint!])
                UIView.animate(withDuration: duration, animations: {
                    self.messagesTableView.contentOffset.y += frame.height - 40
                    self.view.layoutIfNeeded()
                }) { (completed) in
                    if completed {
                        self.keyboardIsShown = true
                    }
                }
            }
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: NSNotification) {
        if keyboardIsShown {
            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            if let frame = keyboardFrame, let duration = animationDuration {
                messageInputBarBottomConstraint?.isActive = false
                UIView.animate(withDuration: duration, animations: {
                    self.messagesTableView.contentOffset.y += -frame.height + 40
                    self.view.layoutIfNeeded()
                }) { (completed) in
                    if completed {
                        self.keyboardIsShown = false
                    }
                }
            }
        }
    }

    @IBAction func didTapTitleButton(_ sender: Any) {
        if titleButton.isSelected {
            hideChatMenu()
        } else {
            showChatMenu()
        }
    }
    
    @IBAction func didTapSendButton(_ sender: Any) {
        let text = formatMessage(inputTextView.text)
        let message = Message(sender: currentUser, messageId: "2", sentDate: Date().addingTimeInterval(-86400), kind: .text(text))
        inputTextView.text = nil
        inputTextView.delegate = self
        sendMessage(message)
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if inputTextView.textColor == .lightGray {
            inputTextView.text = nil
            inputTextView.textColor = .black
            sendButton.isEnabled = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if inputTextView.text.isEmpty {
            inputTextView.text = "Сообщение"
            inputTextView.textColor = .lightGray
            sendButton.isEnabled = false
        }
    }
}

extension UITableView {
    func scrollToLast(_ animated: Bool) {
        guard numberOfSections > 0 else {
            return
        }

        let lastSection = numberOfSections - 1

        guard numberOfRows(inSection: lastSection) > 0 else {
            return
        }

        let lastRowIndexPath = IndexPath(row: numberOfRows(inSection: lastSection) - 1,
                                          section: lastSection)
        scrollToRow(at: lastRowIndexPath, at: .bottom, animated: animated)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == messagesTableView {
            return messages.count
        }
        return chatMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == messagesTableView {
            if messages[indexPath.row].sender.senderId == currentUser.senderId {
                let cell = messagesTableView.dequeueReusableCell(withIdentifier: "OutgoingMessageCell", for: indexPath) as! OutgoingMessageTableViewCell
                cell.setup(messages[indexPath.row])
                return cell
            } else {
                let cell = messagesTableView.dequeueReusableCell(withIdentifier: "IncomingMessageCell", for: indexPath) as! IncomingMessageTableViewCell
                cell.setup(messages[indexPath.row])
                return cell
            }
        } else {
            let cell = dropdownMenuTableView.dequeueReusableCell(withIdentifier: "ChatMenuCell", for: indexPath) as! ChatMenuCell
            cell.cellNameLabel.text = chatMenuOptions[indexPath.row].name
            cell.cellImageView.image = chatMenuOptions[indexPath.row].image
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == messagesTableView {
            messagesTableView.deselectRow(at: indexPath, animated: false)
        } else {
            dropdownMenuTableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
