//
//  ChatDropDownMenu.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 10.10.2020.
//

import UIKit

struct ChatMenuOption {
    var name: String
    var image: UIImage
    var action: (()->Void)?
}

extension ChatViewController {
     
    var chatMenuOptions: [ChatMenuOption] {
        let chatMenuOptions: [ChatMenuOption] = [
            ChatMenuOption(name: "Открыть профиль", image: UIImage(systemName: "person.crop.circle")!, action: nil),
            ChatMenuOption(name: "Добавить в беседу", image: UIImage(systemName: "plus.message")!, action: nil),
            ChatMenuOption(name: "Поиск сообщений", image: UIImage(systemName: "magnifyingglass")!, action: nil),
            ChatMenuOption(name: "Показать вложения", image: UIImage(systemName: "photo")!, action: nil),
            ChatMenuOption(name: "Отключить уведомления", image: UIImage(systemName: "volume.slash")!, action: nil),
            ChatMenuOption(name: "Очистить историю", image: UIImage(systemName: "trash")!, action: nil),
        ]
        return chatMenuOptions
    }
    
    func setupDropDownMenu() {
        setupTransaparentView()
        
        view.addSubview(dropdownMenu)
        
        dropdownMenuTableView.delegate = self
        dropdownMenuTableView.dataSource = self
        dropdownMenuTableView.register(UINib(nibName: "ChatMenuCell", bundle: nil), forCellReuseIdentifier: "ChatMenuCell")
        
        dropdownMenuTableView.separatorStyle = .none
        dropdownMenuTableView.isScrollEnabled = false
        dropdownMenuTableView.rowHeight = 45
        
        dropdownMenu.translatesAutoresizingMaskIntoConstraints = false
        dropdownMenuTableView.translatesAutoresizingMaskIntoConstraints = false
        
        dropdownMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dropdownMenu.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        dropdownMenu.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        dropdownMenuHeightConstraint = dropdownMenu.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([ dropdownMenuHeightConstraint!])
        
        
        dropdownMenu.addSubview(dropdownMenuTableView)
        
        dropdownMenuTableView.topAnchor.constraint(equalTo: dropdownMenu.topAnchor).isActive = true
        dropdownMenuTableView.leftAnchor.constraint(equalTo: dropdownMenu.leftAnchor).isActive = true
        dropdownMenuTableView.rightAnchor.constraint(equalTo: dropdownMenu.rightAnchor).isActive = true
        dropdownMenuTableView.bottomAnchor.constraint(equalTo: dropdownMenu.bottomAnchor).isActive = true
        view.layoutIfNeeded()
    }
    
    func setupTransaparentView() {
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTransparentView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        
        transparentView.addGestureRecognizer(tapGesture)
        view.addSubview(transparentView)
        
        let topConstraint = transparentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leftConstraint = transparentView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        let rightConstraint = transparentView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        let bottomConstraint = transparentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
        view.layoutIfNeeded()
    }
    
    @objc func didTapTransparentView() {
        chatTitleView.isSelected = false
    }
    
    func showChatMenu() {
        dropdownMenuTableView.scrollToRow(at: IndexPath(row: 5, section: 0), at: .bottom, animated: true)
        dropdownMenuHeightConstraint?.constant = 270
        
        chatTitleView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.transparentView.alpha = 0.5
            self.view.layoutIfNeeded()
        } completion: { completed in
            if completed {
                self.chatTitleView.isUserInteractionEnabled = true
            }
        }
    }

    func hideChatMenu() {
        dropdownMenuTableView.scrollToRow(at: IndexPath(row: 5, section: 0), at: .bottom, animated: true)
        dropdownMenuHeightConstraint?.constant = 0
        
        
        chatTitleView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.transparentView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { (completed) in
            if completed {
                self.chatTitleView.isUserInteractionEnabled = true
            }
        }
    }
}
