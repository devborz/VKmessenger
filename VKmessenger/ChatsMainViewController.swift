//
//  ChatsMainViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 24.10.2020.
//

import UIKit

class ChatsMainViewController: UIViewController {
    // MARK - Outlets
    
    @IBOutlet weak var chatsTableView: UITableView!
    
    // MARK - Properties
    
    var userID = "Me"
    
    var selectedChat: Chat?
    
    let toolBar = UIToolbar()
    
    var items = [UIBarButtonItem]()
    
    var folderNames = ["Все", "Работа", "Личные"]
    
    var foldersPickerView = UIPickerView()
    
    var selectedChatsWhileEditing = [IndexPath]() {
        didSet {
            if items.count == 3 {
                if selectedChatsWhileEditing.count == 0 {
                    items[0].title = "Прочит. все"
                    items[2].isEnabled = false
                } else {
                    items[0].title = "Прочитать"
                    items[2].isEnabled = true
                }
            }
        }
    }
    
    var folderName = "Все"
    
    var chats: [Chat] = [
        Chat(id: "1", name: "Elon Mask", lastMessage: "Как тебе такое?", lastMessageTime: "14:20", chatImage: UIImage(named: "Elon")!, currentUser: User(userId: "Me", userName: "Me"), otherUser: User(userId: "other", userName: "Other")),
        Chat(id: "2", name: "Хабиб Нурмагомедов", lastMessage: "Перезвони", lastMessageTime: "21:00", chatImage: UIImage(named: "Khabib")!, currentUser: User(userId: "Me", userName: "Me"), otherUser: User(userId: "other", userName: "Other")),
        Chat(id: "3", name: "Хамзат Чимаев", lastMessage: "Smeesh all these guys", lastMessageTime: "09:00", chatImage: UIImage(named: "Khamzat")!, currentUser: User(userId: "Me", userName: "Me"), otherUser: User(userId: "other", userName: "Other")),
    ]
    
    var visibleChats = [Chat]()
    
    // MARK - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChatsTableView()
        setupFoldersPickerView()
        setupNavigationBar()
        setupToolBar()
    }
    
    // MARK - Setup methods
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage().withTintColor(UIColor(named: "BackgroundColor")!)
        navigationController?.navigationBar.barTintColor = UIColor(named: "BackgroundColor")
        navigationController?.navigationBar.layoutIfNeeded()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        navigationController?.navigationBar.isTranslucent = false

        definesPresentationContext = true
    }
    
    private func setupFoldersPickerView() {
        foldersPickerView.delegate = self
        foldersPickerView.dataSource = self
        
        foldersPickerView.transform = foldersPickerView.transform.rotated(by: -90 * (.pi/180))
        view.addSubview(foldersPickerView)
        
        foldersPickerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
        
        foldersPickerView.backgroundColor = UIColor(named: "background")!
    }
    
    private func setupChatsTableView() {
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        
        chatsTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        
        chatsTableView.backgroundColor = UIColor(named: "background")!
        chatsTableView.showsVerticalScrollIndicator = true
        chatsTableView.tableFooterView = UIView()
        
        loadChatsForFolder()
        
        chatsTableView.allowsSelectionDuringEditing = true
        chatsTableView.allowsMultipleSelectionDuringEditing = true
        chatsTableView.isDirectionalLockEnabled = true
    }
    
    private func loadChatsForFolder() {
        visibleChats = []
        let chatIDs = chatsOfFolderIDs(name: folderName)
        for chat in chats {
            if chatIDs.contains(chat.id) {
                visibleChats.append(chat)
            }
        }
        chatsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToChat" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.title = selectedChat?.name
            chatVC.chatID = selectedChat?.id
            chatVC.userID = self.userID
            chatVC.chatInfo = selectedChat
        }
    }
}

// MARK - ContextMenuDelegate

extension ChatsMainViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let index = 0
        
        let identifier = "\(index)" as NSString
        
        return UIContextMenuConfiguration(
          identifier: identifier,
          previewProvider: nil) { _ in
            let configureFolderAction = UIAction(
              title: "Настроить папку",
              image: UIImage(systemName: "square.and.pencil")) { _ in
            }
            
            let addChatsAction = UIAction(
              title: "Добавить чаты",
              image: UIImage(systemName: "plus")) { _ in
            }
            
            let removeAction = UIAction(
              title: "Убрать",
              image: UIImage(systemName: "trash"),
              attributes: .destructive) { _ in
            }
        
            return UIMenu(title: "", image: nil, children: [configureFolderAction, addChatsAction, removeAction])
        }
    }
}

// MARK - TableViewDelegate

extension ChatsMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatsTableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        cell.setup(visibleChats[indexPath.row].id,
            chatImage: visibleChats[indexPath.row].chatImage,
            chatName: visibleChats[indexPath.row].name,
            lastMessage: visibleChats[indexPath.row].lastMessage,
            lastTime: visibleChats[indexPath.row].lastMessageTime
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            let index = selectedChatsWhileEditing.firstIndex(of: indexPath)
            
            guard let i = index else {
                return
            }
            
            selectedChatsWhileEditing.remove(at: i)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            selectedChatsWhileEditing.append(indexPath)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            selectedChat = visibleChats[indexPath.row]
            
            let chatVC = ChatViewController()
            chatVC.title = self.visibleChats[indexPath.row].name
            chatVC.chatID = self.visibleChats[indexPath.row].id
            chatVC.userID = self.userID
            chatVC.chatInfo = self.visibleChats[indexPath.row]
            chatVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить", handler: { _,_,_ in
            self.visibleChats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        let muteAction = UIContextualAction(style: .normal, title: "Убрать звук", handler: { _,view,_ in
            tableView.deselectRow(at: indexPath, animated: true)
        })
        return UISwipeActionsConfiguration(actions: [deleteAction, muteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let readAction = UIContextualAction(style: .normal, title: "Прочитать", handler: { _,_,_ in
            
        })
        return UISwipeActionsConfiguration(actions: [readAction])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return self.contextMenuConfiguration(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            guard let identifier = configuration.identifier as? String,
                  let index = Int(identifier) else {
                  return
            }
            let chatVC = ChatViewController()
            chatVC.title = self.visibleChats[index].name
            chatVC.chatID = self.visibleChats[index].id
            chatVC.userID = self.userID
            chatVC.chatInfo = self.visibleChats[index]
            chatVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    private func contextMenuConfiguration(_ indexPath: IndexPath) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.row)" as NSString
        let chatVC = ChatViewController()
        chatVC.title = self.visibleChats[indexPath.row].name
        chatVC.chatID = self.visibleChats[indexPath.row].id
        chatVC.userID = self.userID
        chatVC.chatInfo = self.visibleChats[indexPath.row]
        return UIContextMenuConfiguration(
            identifier: identifier, previewProvider: { chatVC }) { _ in

            let answerAction = UIAction(
                title: "Ответить",
                image: UIImage(systemName: "arrowshape.turn.up.backward")) { _ in
            }
            
            let copyAction = UIAction(
                title: "Скопировать",
                image: UIImage(systemName: "square.on.square")) { _ in
            }
            
            let shareAction = UIAction(
                title: "Переслать",
                image: UIImage(systemName: "arrowshape.turn.up.forward")) { _ in
            }
            
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive) { _ in
            }
            
            return UIMenu(title: "", image: nil, children: [answerAction, copyAction, shareAction, deleteAction])
        }
    }
}

// MARK - PickerViewDelegate

extension ChatsMainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return folderNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let modeView = UIView()
        modeView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let modeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        modeLabel.text = folderNames[row]
        modeLabel.textAlignment = .center
        modeView.addSubview(modeLabel)
    
        modeView.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        return modeView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if folderNames[row] != folderName {
            folderName = folderNames[row]
            loadChatsForFolder()
        }
    }
}

// MARK - Toolbar

extension ChatsMainViewController {
    private func beginEditingMode() {
        chatsTableView.setEditing(true, animated: true)
        toolBar.alpha = 0
        tabBarController?.tabBar.addSubview(toolBar)
        UIView.animate(withDuration: 0.3) {
            self.toolBar.alpha = 1
        }
    }
    
    private func endEditingMode() {
        selectedChatsWhileEditing = []
        chatsTableView.setEditing(false, animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.toolBar.alpha = 0
        }) { (completed) in
            if completed {
                self.toolBar.removeFromSuperview()
            }
        }
    }

    @IBAction func didTapEditButton(_ sender: UIButton) {
        if sender.isSelected {
            endEditingMode()
            sender.isSelected = false
            sender.setNeedsLayout()
        } else {
            beginEditingMode()
            sender.isSelected = true
            sender.contentMode = .scaleAspectFit
        }
    }

    private func setupToolBar() {
        if var frame = tabBarController?.tabBar.frame {
            frame.origin = CGPoint(x: 0, y: 0)
            frame.size.height = 50
            toolBar.frame = frame
        }
    
        items.append(UIBarButtonItem(title: "Прочит. все", style: .plain, target: self, action: #selector(didTapReadButton)))
        items.append(UIBarButtonItem(systemItem: .flexibleSpace))
        items.append(UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(didTapDeleteButton)))
        
        items[2].isEnabled = false
        toolBar.items = items
    }
    
    @objc private func didTapReadButton() {
        readSelectedChats()
    }
    
    @objc private func didTapDeleteButton() {
        deleteSelectedChats()
    }
    
    func readSelectedChats() {
        selectedChatsWhileEditing.forEach { (indexPath) in
            chatsTableView.deselectRow(at: indexPath, animated: false)
        }
        selectedChatsWhileEditing = []
    }
    
    func deleteSelectedChats() {
        for chatIndexPath in selectedChatsWhileEditing {
            if let chatIndex = chats.firstIndex(where: { (chat) -> Bool in
                return chat.id == visibleChats[chatIndexPath.row].id
            }) {
                chats.remove(at: chatIndex)
            }
        }
        
        selectedChatsWhileEditing = selectedChatsWhileEditing.sorted(by: { (first, second) -> Bool in
            return first.row > second.row
        })
        
        for chat in selectedChatsWhileEditing {
            visibleChats.remove(at: chat.row)
        }
        
        chatsTableView.deleteRows(at: selectedChatsWhileEditing, with: .automatic)
        
        selectedChatsWhileEditing = []
    }
}
