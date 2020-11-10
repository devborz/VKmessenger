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
    
    var messages = [[Message]]()
    
    var indexPathOfDeletedMessage: IndexPath?
    
    var transparentView = UIView()
    
    var dropdownMenuTableView = UITableView()
    
    var dropdownMenu = ChatDropDownMenuView()
    
    var dropdownMenuHeightConstraint: NSLayoutConstraint?
    
    var messagesTableView = UITableView()
    
    var inputBar = InputBarView()
    
    var inputBarBottomConstraint: NSLayoutConstraint?
    
    var chatTitleView = ChatTitleView()
    
    var chatInfo: Chat?
    
    var keyboardIsShown = false
    
    var shouldScrollToLastRow = true
    
    var bottomBarHeight: CGFloat?
    
    var chatMenuOptions: [ChatMenuOption] {
        let chatMenuOptions: [ChatMenuOption] = [
            ChatMenuOption(name: "Открыть профиль", imageName: "person.crop.circle", action: {
                
            }),
            ChatMenuOption(name: "Добавить в беседу", imageName: "plus.message", action: {
                
            }),
            ChatMenuOption(name: "Поиск сообщений", imageName: "magnifyingglass", action: {
                
            }),
            ChatMenuOption(name: "Показать вложения", imageName: "photo", action: {
                
            }),
            ChatMenuOption(name: "Отключить уведомления", imageName: "volume.slash", action: {
                
            }),
            ChatMenuOption(name: "Очистить историю", imageName: "trash", action: {
                self.chatTitleView.isSelected = false
                let alertController = UIAlertController(title: nil, message: "Вы действительно хотите удалить историю сообщений?", preferredStyle: .actionSheet)
        
                let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                    self.messages.removeAll()
                    let numberOfSections = self.messagesTableView.numberOfSections
                    self.messagesTableView.deleteSections(IndexSet(integersIn: 0..<numberOfSections), with: .fade)
                }
                let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
                }
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }),
        ]
        return chatMenuOptions
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColorScheme()
        setupNavigationBar()
        setupTitleView()
        setupMessagesTableView()
        setupInputBar()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideKeyboard()
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func setupColorScheme() {
        view.backgroundColor = .systemBackground
        inputBar.backgroundColor = .systemBackground
    }
    
    func setupMessagesTableView() {
        messages = DataProcesser.getMessages(chatInfo!)
        view.addSubview(messagesTableView)
        
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        messagesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messagesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messagesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let bottomConstaint = messagesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstaint.priority = UILayoutPriority(rawValue: 500)
        bottomConstaint.isActive = true
        messagesTableView.register(UINib(nibName: "OutgoingMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "OutgoingMessageCell")
        messagesTableView.register(UINib(nibName: "OutgoingVoiceMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "OutgoingVoiceMessageCell")
        messagesTableView.register(UINib(nibName: "IncomingMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomingMessageCell")
        messagesTableView.register(UINib(nibName: "IncomingVoiceMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomingVoiceMessageCell")
        
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        messagesTableView.addGestureRecognizer(tap)
        
        messagesTableView.separatorStyle = .none
        
        shouldScrollToLastRow = true
        
        messagesTableView.allowsSelectionDuringEditing = true
        messagesTableView.allowsMultipleSelectionDuringEditing = true
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
        inputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        inputBar.delegate = self
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.layer.borderWidth = 0
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func setupTitleView() {
        navigationItem.title = nil
        navigationItem.leftItemsSupplementBackButton = true
        
        chatTitleView.delegate = self
        chatTitleView.dataSource = self
        
        chatTitleView.widthAnchor.constraint(equalToConstant: (view.frame.width - NSAttributedString(string: "Готово").size().width) * 0.7).isActive = true
        chatTitleView.sizeToFit()
        let barItem = UIBarButtonItem(customView: chatTitleView)
        navigationItem.setLeftBarButton(barItem, animated: false)
    }
    
    func setupDropDownMenu() {
        view.addSubview(dropdownMenu)
        
        dropdownMenu.delegate = self
        
        dropdownMenu.dataSource = self
        
        dropdownMenu.translatesAutoresizingMaskIntoConstraints = false
        
        dropdownMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dropdownMenu.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        dropdownMenu.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        dropdownMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.layoutIfNeeded()
    }
    
    func setupKeyBoardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    func startEditingMode() {
        messagesTableView.setEditing(true, animated: true)
        inputBar.removeFromSuperview()
    
        let deleteBarItem = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action:  #selector(didTapToolBarDeleteButton))
        
        let shareBarItem = UIBarButtonItem(title: "Переслать", style: .plain, target: self, action:  #selector(didTapToolBarShareButton))
        
        let doneItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action:
            #selector(didTapTopRightButton))
        
        deleteBarItem.tintColor = .red
        
        toolbarItems = [deleteBarItem, .flexibleSpace(), shareBarItem]
        navigationController?.setToolbarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = doneItem
    }
    
    func endEditingMode() {
        messagesTableView.setEditing(false, animated: true)
        navigationController?.setToolbarHidden(true, animated: true)
        setupInputBar()
    }
    
    @objc func didTapTopRightButton() {
        self.navigationItem.rightBarButtonItem = nil
        endEditingMode()
    }
    
    @objc func didTapToolBarDeleteButton() {
        let selectedRows = messagesTableView.indexPathsForSelectedRows?.sorted(by: {
            if $0.section == $1.section { return $0.row > $1.row }
            else { return $0.section > $1.section }
        })
        
        guard let rows = selectedRows else { return }
        
        var emptySections = IndexSet()
        for message in rows {
            messages[message.section].remove(at: message.row)
            if messages[message.section].count == 0 {
                emptySections.insert(IndexSet.Element(message.section))
            }

        }
        
        messagesTableView.deleteRows(at: rows, with: .fade)
        
        for section in emptySections {
            messages.remove(at: section)
        }
        messagesTableView.deleteSections(emptySections, with: .fade)
    }
    
    @objc func didTapToolBarShareButton() {
        
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
        setupDropDownMenu()
        dropdownMenu.show()
    }
    
    func didDeselectTitleView(_ chatTitleView: ChatTitleView) {
        dropdownMenu.hide()
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

extension ChatViewController: ChatDropDownMenuViewDelegate, ChatDropDownMenuViewDataSource {
    func didTapTransparentView() {
        messagesTableView.reloadData()
    }
    
    func titleView() -> ChatTitleView {
        return chatTitleView
    }
    
    func numberOfRows() -> Int {
        return chatMenuOptions.count
    }
    
    func chatMenu(optionForRow row: Int) -> ChatMenuOption {
        return chatMenuOptions[row]
    }
}
