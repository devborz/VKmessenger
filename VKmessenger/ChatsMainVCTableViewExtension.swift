//
//  ChatsMainVCTableViewExtension.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 09.11.2020.
//

import UIKit

// MARK - TableViewDelegate

extension ChatsMainViewController: UITableViewDelegate, UITableViewDataSource {

    func setupChatsTableView() {
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        
        chatsTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        
        chatsTableView.showsVerticalScrollIndicator = true
        chatsTableView.tableFooterView = UIView()
        
        loadChatsForFolder()
        
        chatsTableView.allowsSelectionDuringEditing = true
        chatsTableView.allowsMultipleSelectionDuringEditing = true
        chatsTableView.isDirectionalLockEnabled = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatsTableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        var chatName: String?
        
        switch visibleChats[indexPath.row].type {
        case .groupChat(let name, _): chatName = name
        case .privateChat(let user): chatName = user.userName
        }
        
        guard let name = chatName else {
            return UITableViewCell()
        }
        
        cell.setup(visibleChats[indexPath.row].id,
            chatImage: visibleChats[indexPath.row].chatImage,
            chatName: name,
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
            
            var chatName: String?
            
            switch visibleChats[indexPath.row].type {
            case .groupChat(let name, _): chatName = name
            case .privateChat(let user): chatName = user.userName
            }
            
            guard let name = chatName else {
                return
            }
            
            chatVC.title = name
            chatVC.chatInfo = self.visibleChats[indexPath.row]
            chatVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить", handler: { _,_,_ in
            let alertController = UIAlertController(title: nil, message: "Вы действительно хотите удалить историю сообщений?", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                self.deleteChat(indexPath)
                self.chatsTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true) {
                tableView.cellForRow(at: indexPath)?.endEditing(true)
            }
        })
        let muteAction = UIContextualAction(style: .normal, title: "Убрать звук", handler: { _,_,_ in
            tableView.cellForRow(at: indexPath)?.endEditing(true)
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
            
            var chatName: String?
            
            switch self.visibleChats[index].type {
            case .groupChat(let name, _): chatName = name
            case .privateChat(let user): chatName = user.userName
            }
            
            guard let name = chatName else {
                return
            }
            
            chatVC.title = name
            chatVC.chatInfo = self.visibleChats[index]
            chatVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    private func contextMenuConfiguration(_ indexPath: IndexPath) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.row)" as NSString
        let chatVC = ChatViewController()
        
        var chatName: String?
        
        switch visibleChats[indexPath.row].type {
        case .groupChat(let name, _): chatName = name
        case .privateChat(let user): chatName = user.userName
        }
        
        guard let name = chatName else {
            return nil
        }
        
        chatVC.title = name
        chatVC.chatInfo = self.visibleChats[indexPath.row]
        return UIContextMenuConfiguration(
            identifier: identifier, previewProvider: { chatVC }) { _ in
            
            let muteAction = UIAction(
                title: "Отключить уведомления",
                image: UIImage(systemName: "volume.slash")) { _ in
            }
                
            let unmuteAction = UIAction(
                title: "Включить уведомления",
                image: UIImage(systemName: "volume.2")) { _ in
            }
                
            let readAction = UIAction(
                title: "Отметить прочитанным",
                image: UIImage(systemName: "checkmark")) { _ in
            }
            
            let unreadAction = UIAction(
                title: "Отметить непрочитанным",
                image: UIImage(systemName: "circle.fill")) { _ in
            }
            
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive) { _ in
                let alertController = UIAlertController(title: nil, message: "Вы действительно хотите удалить историю сообщений?", preferredStyle: .actionSheet)
                
                let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                    self.deleteChat(indexPath)
                    self.chatsTableView.deleteRows(at: [indexPath], with: .automatic)
                }
                let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            return UIMenu(title: "", image: nil, children: [muteAction, unmuteAction, readAction, unreadAction, deleteAction])
        }
    }
}
