//
//  ChatsMenuViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 30.09.2020.
//

import UIKit
import FirebaseDatabase

class ChatsMenuViewController: UIViewController {
    
    @IBOutlet weak var foldersView: UICollectionView!
    
    var selectedChat = IndexPath()
    
    var chatSearchController = UISearchController(searchResultsController: nil)
    
    let dropDownMenu = UITableView()
    
    let transparentView = UIView()
    
    var userToken: String?
    
    var userID: String?
    
    var selectedRow: IndexPath?
    
    var selectedChatFolderName: String = "Все"
    
    let chats: [[String]] = [
        ["1", "Test chat 1", "Hello", "14:24"],
        ["2", "Test chat 2", "wassap", "13:20"],
        ["3", "Test chat 3", "Yooooo", "12:20"],
        ["4", "Test chat 4", "cho kak", "14:24"],
        ["5", "Test chat 5", "vaçok", "13:20"],
        ["6", "Test chat 6", "Muha vu", "12:20"],
        ["6", "Test chat 6", "Muha vu", "12:20"],
        ["6", "Test chat 6", "Muha vu", "12:20"],
        ["6", "Test chat 6", "Muha vu", "12:20"],
        ["6", "Test chat 6", "Muha vu", "12:20"],
        ["6", "Test chat 6", "Muha vu", "12:20"],
    ]
    
    var visibleChats = [[String]]()
    let folders: [String] = ["Все", "Учеба", "Кино"]
    
    @IBOutlet weak var chatsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchBar()
        setupChatsTableView()
        setupFolderView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        chatSearchController.searchBar.resignFirstResponder()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        navigationItem.searchController = chatSearchController
        definesPresentationContext = true
    }
    
    private func setupFolderView() {
        foldersView.translatesAutoresizingMaskIntoConstraints = false
        
        foldersView.delegate = self
        foldersView.dataSource = self
        foldersView.register(UINib(nibName: "FolderCell", bundle: nil), forCellWithReuseIdentifier: "FolderCell")
        foldersView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
    }
    
    private func setupChatsTableView() {
        visibleChats = chats
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        chatsTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        
        chatsTableView.showsVerticalScrollIndicator = true
        chatsTableView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
        chatsTableView.separatorStyle = .none
    }
    
    private func setupSearchBar() {
        chatSearchController.searchResultsUpdater = self
        chatSearchController.obscuresBackgroundDuringPresentation = false
        chatSearchController.searchBar.placeholder = "Поиск"
        let height = chatSearchController.searchBar.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([height])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToChat" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.title = visibleChats[selectedChat.row][1]
            chatVC.chatID = visibleChats[selectedChat.row][0]
            chatVC.userID = self.userID
        }
    }
}

extension ChatsMenuViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
