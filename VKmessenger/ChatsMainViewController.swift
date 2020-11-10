//
//  ChatsMainViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 24.10.2020.
//

import UIKit

class ChatsMainViewController: UIViewController {
    // MARK - Outlets
    
    @IBOutlet weak var foldersCollectionView: UICollectionView!
    
    @IBOutlet weak var chatsTableView: UITableView!
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    // MARK - Properties
    
    var userID = "Me"
    
    var selectedChat: Chat?
    
    let toolBar = UIToolbar()
    
    var items = [UIBarButtonItem]()
    
    var folderNames = ["Все", "Работа", "Личные"]
    
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
        setupFoldersCollectionView()
        setupNavigationBar()
        setupToolBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK - Setup methods
    
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(named: "headerColor")
        navigationController?.navigationBar.layoutIfNeeded()
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold), NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        definesPresentationContext = true
    }
    
    func setupFoldersCollectionView() {
        foldersCollectionView.delegate = self
        foldersCollectionView.dataSource = self
        
        foldersCollectionView.register(UINib(nibName: "FolderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FolderCell")
        
        foldersCollectionView.backgroundColor = UIColor(named: "headerColor")
        
        foldersCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .bottom)
        
        foldersCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func loadChatsForFolder() {
        visibleChats = []
        let chatIDs = chatsOfFolderIDs(name: folderName)
        for chat in chats {
            if chatIDs.contains(chat.id) {
                visibleChats.append(chat)
            }
        }
        chatsTableView.reloadData()
    }
    
    func deleteChat(_ indexPath: IndexPath) {
        if let chatIndex = chats.firstIndex(where: { (chat) -> Bool in
            return chat.id == visibleChats[indexPath.row].id
        }) {
            chats.remove(at: chatIndex)
        }
        visibleChats.remove(at: indexPath.row)
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

// MARK - Folders Collection View

extension ChatsMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        folderNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCollectionViewCell
        cell.nameLabel.text = folderNames[indexPath.item]
        cell.nameLabel.sizeToFit()
        if cell.isSelected {
            cell.select(false)
        } else {
            cell.deselect(false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if folderNames[indexPath.item] != folderName {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            folderName = folderNames[indexPath.item]
            loadChatsForFolder()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

