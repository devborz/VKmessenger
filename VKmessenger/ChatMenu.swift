//
//  ChatDropDownMenu.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 10.10.2020.
//

import UIKit

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
    
    internal func setupDropDownMenu() {
        setupTransaparentView()
        
        view.addSubview(dropdownMenu)
        
        dropdownMenuTableView.delegate = self
        dropdownMenuTableView.dataSource = self
        dropdownMenuTableView.register(UINib(nibName: "ChatMenuCell", bundle: nil), forCellReuseIdentifier: "ChatMenuCell")
        
        dropdownMenuTableView.separatorStyle = .none
        dropdownMenuTableView.isScrollEnabled = false
        dropdownMenuTableView.rowHeight = 45
        dropdownMenu.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = dropdownMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leftConstraint = dropdownMenu.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        let rightConstraint = dropdownMenu.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        dropdownMenuHeightConstraint = dropdownMenu.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, dropdownMenuHeightConstraint!])
        view.layoutIfNeeded()
    }
    
    private func setupTransaparentView() {
        transparentView.translatesAutoresizingMaskIntoConstraints = false
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideChatMenu))
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
    
    internal func showChatMenu() {
        dropdownMenuTableView.scrollToRow(at: IndexPath(row: 5, section: 0), at: .bottom, animated: true)
        dropdownMenuHeightConstraint?.constant = 270
        
        UIView.animate(withDuration: 0.3) {
            self.transparentView.alpha = 0.5
            self.view.layoutIfNeeded()
            self.titleButton.imageView?.transform = (self.titleButton.imageView?.transform.rotated(by: CGFloat(Double.pi)))!
        } completion: { completed in
            if completed {
                self.titleButton.isSelected = true
            }
        }
    }

    @objc internal func hideChatMenu() {
        dropdownMenuTableView.scrollToRow(at: IndexPath(row: 5, section: 0), at: .bottom, animated: true)
        dropdownMenuHeightConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.transparentView.alpha = 0
            self.view.layoutIfNeeded()
            self.titleButton.imageView?.transform = (self.titleButton.imageView?.transform.rotated(by: CGFloat(Double.pi)))!
        } completion: { (completed) in
            if completed {
                self.titleButton.isSelected = false
            }
        }
    }
}
