//
//  UserProfileViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 12.11.2020.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var user: User?
    
    let avatarImageView = UIImageView()
    
    let userNameLabel = UILabel()

    let lastActivityLabel = UILabel()
    
    let goToChatButton = UIButton()
    
    var tabBarWasHidden: Bool?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarWasHidden = tabBarController?.tabBar.isHidden
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user?.userId
        view.backgroundColor = .systemBackground
        
        setupNaigationBar()
        setupAvatarView()
        setupNameLabel()
        setupActivityLabel()
        setupGoToChatButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let wasHidden = tabBarWasHidden else { return }
        tabBarController?.tabBar.isHidden = wasHidden
    }
    
    func setupNaigationBar() {
        navigationItem.backButtonTitle = " "
    }
    
    func setupAvatarView() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(avatarImageView)
        avatarImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        avatarImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        
        avatarImageView.backgroundColor = .white
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.image = user?.avatar
        
        avatarImageView.contentMode = .scaleAspectFill
        view.layoutIfNeeded()
    }
    
    func setupNameLabel() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(userNameLabel)
        userNameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        userNameLabel.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        guard let user = user else {
            return
        }
        userNameLabel.text = user.userName
        userNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    func setupActivityLabel() {
        lastActivityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lastActivityLabel)
        lastActivityLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10).isActive = true
        lastActivityLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5).isActive = true
        lastActivityLabel.rightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        guard user != nil else {
            return
        }
        lastActivityLabel.text = "Activity"
        lastActivityLabel.textColor = .systemGray
    }
    
    func setupGoToChatButton() {
        goToChatButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(goToChatButton)
        
        goToChatButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 30).isActive = true
        goToChatButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        goToChatButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        goToChatButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        goToChatButton.backgroundColor = UIColor(named: "headerColor")
        goToChatButton.layer.cornerRadius = 5
        goToChatButton.setTitle("Сообщение", for: .normal)
        goToChatButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        goToChatButton.addTarget(self, action: #selector(didTapGoToChatButton), for: .touchUpInside)
    }
    
    @objc func didTapGoToChatButton() {
        let chatVC = ChatViewController()
        
        guard let user = user else { return }
        
        if let chatInfo = DataProcesser.getChat(withUser: user) {
            chatVC.chatInfo = chatInfo
        } else {
            chatVC.chatInfo = DataProcesser.createChat(withUser: user)
        }
        
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
