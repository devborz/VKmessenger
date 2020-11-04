//
//  ChatViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 01.10.2020.
//

import UIKit

class ChatViewController: UIViewController {
    
    var chatID: String?
    
    var userID: String?
    
    var messages = [Message]()
    
    var indexPathOfDeletedMessage: IndexPath?
    
    var transparentView = UIView()
    
    var dropdownMenuTableView = UITableView()
    
    var dropdownMenu = UIView()
    
    var dropdownMenuHeightConstraint: NSLayoutConstraint?
    
    var messagesTableView = UITableView()
    
    var inputBar = InputBarView()
    
    var inputBarBottomConstraint: NSLayoutConstraint?
    
    var chatTitleView = ChatTitleView()
    
    var chatInfo: Chat?
    
    var keyboardIsShown = false
    
    var shouldScrollToLastRow = true
    
    var bottomBarHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDissmissalGestureRecognizer()
        setupColorScheme()
        setupNavigationBar()
        setupMessagesTableView()
        setupInputBar()
        setupDropDownMenu()
        setupKeyBoardObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomBarHeight = view.frame.height - view.safeAreaLayoutGuide.layoutFrame.maxY
        if shouldScrollToLastRow {
            shouldScrollToLastRow = false
            messagesTableView.scrollTableViewToBottom(false)
        }
    }
    
    func setupDissmissalGestureRecognizer() {
        let popGestureRecognizer = self.navigationController!.interactivePopGestureRecognizer!
        if let targets = popGestureRecognizer.value(forKey: "targets") as? NSMutableArray {
          let gestureRecognizer = UIPanGestureRecognizer()
          gestureRecognizer.setValue(targets, forKey: "targets")
          self.view.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    func setupColorScheme() {
        view.backgroundColor = UIColor(named: "BackgroundColor")!
        messagesTableView.backgroundColor = .systemBackground
        inputBar.backgroundColor = UIColor(named: "BackgroundColor")!
    }
    
    func setupMessagesTableView() {
        messages = Data.getMessages(chatInfo!)
        view.addSubview(messagesTableView)
        
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        messagesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messagesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messagesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        messagesTableView.register(UINib(nibName: "OutgoingMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "OutgoingMessageCell")
        messagesTableView.register(UINib(nibName: "IncomingMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomingMessageCell")
        
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        messagesTableView.addGestureRecognizer(tap)
        
        messagesTableView.separatorStyle = .none
        
        shouldScrollToLastRow = true
    }
    
    @objc func hideKeyboard() {
        inputBar.inputTextView.resignFirstResponder()
    }
    
    func setupInputBar() {
        
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(inputBar)
        
        inputBar.topAnchor.constraint(equalTo: messagesTableView.bottomAnchor).isActive = true
        inputBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        inputBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
 
        let messageInputBarBottomConstraint = inputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        messageInputBarBottomConstraint.isActive = true
        messageInputBarBottomConstraint.priority = UILayoutPriority(rawValue: 500)
        
        inputBar.delegate = self
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.layer.borderWidth = 0
        navigationController?.navigationBar.layoutIfNeeded()
        navigationController?.navigationBar.backgroundColor = UIColor(named: "BackgroundColor")
        setupTitleView()
    }
    
    func setupTitleView() {
        navigationItem.title = nil
        navigationItem.leftItemsSupplementBackButton = true
        
        chatTitleView.delegate = self
        chatTitleView.dataSource = self
        
        chatTitleView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.7).isActive = true
        
        let barItem = UIBarButtonItem(customView: chatTitleView)
        navigationItem.setLeftBarButton(barItem, animated: false)
    }
    
    func setupKeyBoardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    @objc func handleKeyboardWillChangeFrame(notification: NSNotification) {
        if keyboardIsShown {
        
        }
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        if !keyboardIsShown {
            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            
            if let frame = keyboardFrame, let duration = animationDuration {
                inputBarBottomConstraint?.isActive = false
                inputBarBottomConstraint = inputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -frame.height + bottomBarHeight!)
                NSLayoutConstraint.activate([inputBarBottomConstraint!])
                UIView.animate(withDuration: duration, animations: {
                    self.messagesTableView.contentOffset.y += frame.height - self.bottomBarHeight!
                    self.view.layoutIfNeeded()
                }) { (completed) in
                    if completed {
                        self.keyboardIsShown = true
                    }
                }
            }
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        if keyboardIsShown {

            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            
            if let frame = keyboardFrame, let duration = animationDuration {
                inputBarBottomConstraint?.isActive = false
                UIView.animate(withDuration: duration, animations: {
                    self.messagesTableView.contentOffset.y += -frame.height + self.bottomBarHeight!
                    self.view.layoutIfNeeded()
                }) { (completed) in
                    if completed {
                        self.keyboardIsShown = false
                    }
                }
            }
        }
    }
    
    @objc func didTapTopRightButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ChatViewController: InputBarViewDelegate {
    
    func didEndRecording(_ inputBarView: InputBarView, voiceMesage: String) {
        
    }
    
    func didPressSendButton(_ inputBarView: InputBarView, with textInTextView: String) {
        let text = formatMessage(inputBarView.inputTextView.text)
        let message = Message(sender: chatInfo!.currentUser, messageId: "2", sentDate: Date().addingTimeInterval(-86400), kind: .text(text))
        sendMessage(message)
    }
    
    func didPressAttachButton(_ inputBar: InputBarView) {
        
    }
    
}

extension ChatViewController: ChatTitleViewDelegate, ChatTitleViewDataSource {
    
    func didSelectTitleView(_ chatTitleView: ChatTitleView) {
        inputBar.inputTextView.resignFirstResponder()
        showChatMenu()
    }
    
    func didDeselectTitleView(_ chatTitleView: ChatTitleView) {
        hideChatMenu()
    }
    
    func setImage(_ chatTitleView: ChatTitleView) -> UIImage? {
        return chatInfo?.chatImage
    }
    
    func setName(_ chatTitleView: ChatTitleView) -> String? {
        return chatInfo?.name
    }
    
}

extension UITableView {
    func scrollTableViewToBottom(_ animated: Bool) {
        guard let dataSource = dataSource else { return }
        
        let lastRow = dataSource.tableView(self, numberOfRowsInSection: 0) - 1
        
        guard lastRow > -1 else { return }
        
        let bottomIndex = IndexPath(row: lastRow, section: 0)
        
        scrollToRow(at: bottomIndex, at: .bottom, animated: animated)
    }
}
