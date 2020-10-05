//
//  MainViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 30.09.2020.
//

import UIKit
import WebKit
import FirebaseDatabase

class MainViewController: UIViewController {
    
    @IBOutlet weak var chatSearchBar: UISearchBar!
    @IBOutlet weak var foldersView: UICollectionView!
    
    var userToken: String?
    var userID: String?
    var webView: WKWebView?
    var selectedChatFolderName: String = "Все"
    
    let chats: [[String]] = [
        ["1", "Test chat 1", "Hello", "14:24"],
        ["2", "Test chat 2", "wassap", "13:20"],
        ["3", "Test chat 3", "Yooooo", "12:20"],
        ["4", "Test chat 4", "cho kak", "14:24"],
        ["5", "Test chat 5", "vaçok", "13:20"],
        ["6", "Test chat 6", "Muha vu", "12:20"],
    ]
    
    var visibleChats = [[String]]()
    let folders: [String] = ["Все", "Учеба", "Кино"]
    
    @IBOutlet weak var chatsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorize()
        visibleChats = chats
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        chatsTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        setupFolderView()
        foldersView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func authorize() {
        let ref = Database.database().reference()
        ref.child("userToken").observe(.value) { (snap) in
            let data = snap.value as? String
            if let token = data {
                self.userToken = token
            }
        }
        ref.child("userID").observe(.value) { (snap) in
            let data = snap.value as? String
            if let userID = data {
                self.userID = userID
            }
        }
        
        if self.userToken == nil || self.userID == nil {
            webView = WKWebView(frame: view.frame)
            webView?.tag = 1024
            view.addSubview(webView!)
            
            let url = URL(string: "http://oauth.vk.com/authorize?client_id=7614415&scope=wall,offline&redirect_url=oauth.vk.com/blank.html&display=touch&response_type=token")
            let urlRequest = URLRequest(url: url!)
            webView?.load(urlRequest)
            
            webView?.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(WKWebView.url) {
            self.userToken = self.webView?.url?.absoluteString
            self.webView?.removeFromSuperview()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        chatSearchBar.resignFirstResponder()
    }
    
    private func setupFolderView() {
        foldersView.translatesAutoresizingMaskIntoConstraints = false
        foldersView.delegate = self
        foldersView.dataSource = self
        foldersView.register(UINib(nibName: "FolderCell", bundle: nil), forCellWithReuseIdentifier: "FolderCell")
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatsTableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        cell.setup(
            visibleChats[indexPath.row][0],
            chatImage: UIImage(), chatName:
            visibleChats[indexPath.row][1], lastMessage:
            visibleChats[indexPath.row][2], lastTime:
            visibleChats[indexPath.row][3]
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatsTableView.deselectRow(at: indexPath, animated: true)
        let chatVC = ChatViewController()
        chatVC.title = visibleChats[indexPath.row][1]
        chatVC.chatID = visibleChats[indexPath.row][0]
        chatVC.userID = self.userID
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = foldersView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
        cell.setup(folders[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: .zero)
        label.text = folders[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 20, height: 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedChatFolderName = folders[indexPath.item]
        let chatIDs = chatsOfFolderIDs(name: selectedChatFolderName)
        visibleChats = chats.filter {
            chatIDs.contains($0[0])
        }
        chatsTableView.reloadData()
    }
}

extension MainViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        <#code#>
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        <#code#>
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        <#code#>
//    }
}
