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
    
    var userToken: String?
    var userID: String?
    var webView: WKWebView?
    let chats: [[String]] = [["chatID", "Test chat", "Hello", "14:24"]]
    
    @IBOutlet weak var chatsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authorize()
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        chatsTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
    }
    
    func authorize() {
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
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatsTableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        cell.setup(chats[indexPath.row][0], chatImage: UIImage(), chatName: chats[indexPath.row][1], lastMessage: chats[indexPath.row][2], lastTime: chats[indexPath.row][3])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chatsTableView.deselectRow(at: indexPath, animated: true)
        let chatVC = ChatViewController()
        chatVC.title = chats[indexPath.row][1]
        chatVC.chatID = chats[indexPath.row][0]
        chatVC.userID = self.userID
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
