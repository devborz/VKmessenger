//
//  ChatViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 01.10.2020.
//

import UIKit

class ChatViewController: UIViewController {
    
    // MARK: Views
    
    let chatTitleView = ChatTitleView()
    
    let dropdownMenu = ChatDropDownMenuView()
    
    let messagesTableView = UITableView()
    
    let inputBar = InputBarView()
    
    let gradientLayer = CAGradientLayer()
    
    // MARK: Constraints
    
    var dropdownMenuHeightConstraint: NSLayoutConstraint!
    
    var inputBarBottomConstraint: NSLayoutConstraint!
    
    var bottomBarHeight: CGFloat?
    
    // MARK: Delegates
    
    var transitionDelegate: TransitionDelegate?
    
    var messagesDelegate: MessagesDelegate!
    
    // MARK: Data
    
    var chatInfo: Chat!
    
    var messages = [[Message]]()
    
    var attachedItems = [AttachedItem]()
    
    // MARK: Conditions
    
    var indexPathOfDeletedMessage: IndexPath?
    
    var keyboardIsShown = false
    
    var shouldScrollToLastRow = true
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.bottom, .right]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyBoardObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColorScheme()
        setupNavigationBar()
        setupTitleView()
        setupMessagesTableView()
        setupInputBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomBarHeight = view.frame.height - view.safeAreaLayoutGuide.layoutFrame.maxY
        if shouldScrollToLastRow {
            shouldScrollToLastRow = false
            messagesTableView.scrollToLast(false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyBoardObservers()
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func setupNavigationBar() {
        navigationItem.backButtonTitle = " "
    }
    
    func setupColorScheme() {
        view.backgroundColor = UIColor(named: "color")
        inputBar.backgroundColor = UIColor(named: "color")
        messagesTableView.backgroundColor = UIColor(named: "color")
        
        
    }
    
    func setupMessagesTableView() {
        let dataManager = (UIApplication.shared.delegate as! AppDelegate).dataManager
        
        messages = dataManager.getMessages(chatInfo)
        view.addSubview(messagesTableView)
        
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        messagesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messagesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messagesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        let bottomConstraint = messagesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(rawValue: 500)
        bottomConstraint.isActive = true
        
        messagesTableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        messagesTableView.register(UINib(nibName: "OutgoingVoiceMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "OutgoingVoiceMessageCell")
        messagesTableView.register(UINib(nibName: "IncomingVoiceMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "IncomingVoiceMessageCell")
        
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        tap.delaysTouchesBegan = false
        messagesTableView.addGestureRecognizer(tap)
        
        messagesTableView.separatorStyle = .none
        
        shouldScrollToLastRow = true
        
        messagesTableView.allowsSelectionDuringEditing = true
        messagesTableView.allowsMultipleSelectionDuringEditing = true
    }
    
    @objc func didSwipeMessage(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let location = gestureRecognizer.location(in: messagesTableView)
            let indexPath = messagesTableView.indexPathForRow(at: location)
            let cell = messagesTableView.cellForRow(at: indexPath!)
            cell?.setEditing(false, animated: true)
        }
    }
    
    @objc func hideKeyboard() {
        inputBar.textView.resignFirstResponder()
    }
    
    func setupInputBar() {
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(inputBar)
        
        inputBar.topAnchor.constraint(equalTo: messagesTableView.bottomAnchor).isActive = true
        inputBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        inputBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        inputBarBottomConstraint = inputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        inputBarBottomConstraint?.isActive = true
        
        inputBar.delegate = self
        inputBar.dataSource = self
        
        messagesDelegate = inputBar
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyBoardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        if !keyboardIsShown {
            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            
            guard let frame = keyboardFrame, let duration = animationDuration else { return }
            
            inputBarBottomConstraint?.constant = -frame.height + bottomBarHeight!
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
    
    @objc func handleKeyboardWillChangeFrame(notification: NSNotification) {
        if keyboardIsShown {
            let keyboardFrameBegin = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue
            let keyboardFrameEnd = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            
            guard let frameEnd = keyboardFrameEnd,
               let frameBegin = keyboardFrameBegin,
               let duration = animationDuration else { return }
            
            inputBarBottomConstraint?.constant = -frameEnd.height + bottomBarHeight!
            
            UIView.animate(withDuration: duration, animations: {
                self.messagesTableView.contentOffset.y += frameEnd.height - frameBegin.height
                self.view.layoutIfNeeded()
            }) { (completed) in
                if completed {
                    self.keyboardIsShown = true
                }
            }
                
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        if keyboardIsShown {

            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            
            guard let frame = keyboardFrame, let duration = animationDuration else { return }
            
            inputBarBottomConstraint?.constant = 0
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
    
    func startEditingMode() {
        chatTitleView.isUserInteractionEnabled = false
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
        chatTitleView.isUserInteractionEnabled = true
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
            self?.messagesTableView.reloadData()
        })
    }
}

extension ChatViewController: InputBarViewDelegate, InputBarViewDataSource {
    
    func didChangedHeight(_ inputBarView: InputBarView, difference: CGFloat) {
        self.messagesTableView.contentOffset.y += difference
    }
    
    func currentSender(_ inputBarView: InputBarView) -> User {
        return chatInfo.currentUser
    }
    
    func didEndRecording(_ inputBarView: InputBarView, voiceMesage: String) {
        
    }
    
    func didPressSendButton(_ inputBarView: InputBarView, with message: Message) {
        sendMessage(message)
    }
    
    func didPressAttachButton(_ inputBar: InputBarView) {
        presentInputActionSheet()
    }
}

extension ChatViewController: ChatTitleViewDelegate, ChatTitleViewDataSource {
    
    func didSelectTitleView(_ chatTitleView: ChatTitleView) {
        inputBar.textView.resignFirstResponder()
        setupDropDownMenu()
        dropdownMenu.show()
    }
    
    func didDeselectTitleView(_ chatTitleView: ChatTitleView) {
        dropdownMenu.hide()
    }
    
    func setImage(_ chatTitleView: ChatTitleView) -> UIImage? {
        switch chatInfo.type {
        case .groupChat(_,_, let image): return image
        case .privateChat(let user): return user.avatar
        }
    }
    
    func setName(_ chatTitleView: ChatTitleView) -> String? {
        switch chatInfo.type {
        case .privateChat(let user): return user.userName
        case .groupChat(let name, _, _): return name
        }
    }
    
}

extension ChatViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ChatViewController: ChatDropDownMenuViewDelegate, ChatDropDownMenuViewDataSource {
    func chatType() -> ChatType {
        return chatInfo.type
    }
    
    func didSelectOptionClearHistory() {
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
    }
    
    func didSelectOptionOpenProfile() {
        let profileVC = ProfileViewController()
        
        guard let chat = self.chatInfo else {
            return
        }
        switch chat.type {
        case .privateChat(let user):
            profileVC.user = user
        default: return
        }
        
        self.navigationController?.pushViewController(profileVC, animated: true)
        
        self.chatTitleView.isSelected = false
    }
    
    func didSelectOptionAddToChat() {
        
    }
    
    func didSelectOptionShowAttachments() {
        
    }
    
    func didSelectOptionSearch() {
        let searchVC = SearchInChatViewController()
        let navVC = UINavigationController()
        navVC.viewControllers = [searchVC]
        
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .crossDissolve
        
        self.navigationController?.present(navVC, animated: true, completion: nil)
        self.chatTitleView.isSelected = false
    }
    
    func didSelectOptionMute() {
        
    }
    
    func didSelectOptionAddPeople() {
        
    }
    
    func didTapTransparentView() {
        messagesTableView.reloadData()
    }
    
    func isChatMuted() -> Bool {
        return chatInfo?.isMuted ?? false
    }
    
    func didChangeMute() {
        
    }
    
    func titleView() -> ChatTitleView {
        return chatTitleView
    }
}
