//
//  ChatsFolderViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 30.09.2020.
//

import UIKit
import Tabman
import Pageboy

class ChatsFolderViewController: UIViewController {
    
    let chatsTableView = UITableView()
    
    var selectedChat = IndexPath()
    
    var mainVC: ChatsMainViewController?
//    var userToken: String?
//
//    var userID: String?
    
    var folderName = String()
    
    var chats: [[String]] = [
        ["1", "Test chat 1", "Hello", "14:24"],
        ["2", "Test chat 2", "wassap", "13:20"],
        ["3", "Test chat 3", "Yooooo", "12:20"],
        ["4", "Test chat 4", "cho kak", "14:24"],
        ["5", "Test chat 5", "vaçok", "13:20"],
        ["6", "Test chat 6", "Muha vu", "12:20"],
        ["6", "Test chat 7", "Muha vu", "12:20"],
        ["6", "Test chat 8", "Muha vu", "12:20"],
        ["6", "Test chat 9", "Muha vu", "12:20"],
        ["6", "Test chat 10", "Muha vu", "12:20"],
        ["6", "Test chat 11", "Muha vu", "12:20"],
    ]
    
    var visibleChats = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupNavigationBar()
//        setupSearchBar()
        setupChatsTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        chatSearchController.searchBar.resignFirstResponder()
    }
    
    private func setupChatsTableView() {
        
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        
        chatsTableView.backgroundColor = UIColor(named: "BackgroundColor")
        chatsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(chatsTableView)
        
        chatsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        chatsTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        chatsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        chatsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        chatsTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell\(folderName)")
        
        chatsTableView.backgroundColor = UIColor(named: "BackgroundColor")
        chatsTableView.showsVerticalScrollIndicator = true
        chatsTableView.separatorStyle = .none
        
        let chatIDs = chatsOfFolderIDs(name: folderName)
        for chat in chats {
            if chatIDs.contains(chat[0]) {
                visibleChats.append(chat)
            }
        }
    }    

}

extension ChatsFolderViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension ChatsFolderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatsTableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell\(folderName)", for: indexPath) as! ChatTableViewCell
        cell.setup(visibleChats[indexPath.row][0],
            chatImage: UIImage(),
            chatName: visibleChats[indexPath.row][1],
            lastMessage: visibleChats[indexPath.row][2],
            lastTime: visibleChats[indexPath.row][3]
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChat = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        mainVC?.selectedChat = visibleChats[indexPath.row]
        mainVC?.performSegue(withIdentifier: "GoToChat", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить", handler: { _,_,_ in
            self.visibleChats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
