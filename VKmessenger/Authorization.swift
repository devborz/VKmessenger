//
//  Authorization.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 10.10.2020.
//

//import Foundation
//import WebKit
//import FirebaseDatabase
//
//private func authorize() {
//    var userToken: String
//    let ref = Database.database().reference()
//    ref.child("userToken").observe(.value) { (snap) in
//        let data = snap.value as? String
//        if let token = data {
//            userToken = token
//        }
//    }
//    ref.child("userID").observe(.value) { (snap) in
//        let data = snap.value as? String
//        if let userID = data {
//            userID = userID
//        }
//    }
//
//    if userToken == nil || userID == nil {
//        webView = WKWebView(frame: view.frame)
//        webView?.tag = 1024
//        view.addSubview(webView!)
//
//        let url = URL(string: "http://oauth.vk.com/authorize?client_id=7614415&scope=wall,offline&redirect_url=oauth.vk.com/blank.html&display=touch&response_type=token")
//        let urlRequest = URLRequest(url: url!)
//        webView?.load(urlRequest)
//
//        webView?.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
//    }
//}
//
//override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//    if keyPath == #keyPath(WKWebView.url) {
//        self.userToken = self.webView?.url?.absoluteString
//        self.webView?.removeFromSuperview()
//    }
//}
