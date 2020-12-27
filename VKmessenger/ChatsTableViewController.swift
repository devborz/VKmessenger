//
//  ChatsTableViewController.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 10.12.2020.
//

import UIKit

class ChatsTableViewController: UITableViewController {
    
    var folderName: String!
    
    let dataManager = (UIApplication.shared.delegate as! AppDelegate).dataManager
    
    var selectedChatsWhileEditing: [IndexPath] = [] {
        didSet {
            let parentVC = parent as! ChatsViewController
            if parentVC.items.count == 3 {
                if selectedChatsWhileEditing.count == 0 {
                    parentVC.items[0].title = "Прочит. все"
                    parentVC.items[2].isEnabled = false
                } else {
                    parentVC.items[0].title = "Прочитать"
                    parentVC.items[2].isEnabled = true
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        tableView.showsVerticalScrollIndicator = true
        tableView.tableFooterView = UIView()
        
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.isDirectionalLockEnabled = true
        tableView.backgroundColor = .clear
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.getChatsForFolder(folderName).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        cell.setup((UIApplication.shared.delegate as! AppDelegate).dataManager.getChatsForFolder(folderName)[indexPath.row])
        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            let index = selectedChatsWhileEditing.firstIndex(of: indexPath)
            
            guard let i = index else {
                return
            }
            
            selectedChatsWhileEditing.remove(at: i)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            selectedChatsWhileEditing.append(indexPath)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let chat = dataManager.getChatsForFolder(folderName)[indexPath.row]
            
            let chatVC = ChatViewController()
            
            var chatName: String?
            
            switch chat.type {
            case .groupChat(let name, _, _): chatName = name
            case .privateChat(let user): chatName = user.userName
            }
            
            guard let name = chatName else {
                return
            }
            
            chatVC.title = name
            chatVC.chatInfo = chat
            chatVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard !tableView.isEditing else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить", handler: { _,_,_ in
            self.presentAlert {
                let id = (self.tableView.cellForRow(at: indexPath) as! ChatTableViewCell).chatID
                self.deleteChat(id)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } completionForCancel: {
            }
        })
        
        deleteAction.image = UIImage(systemName: "trash")
        
        let chat = dataManager.getChatsForFolder(folderName)[indexPath.row]
        
        let muteActionTitle = chat.isMuted ? "Включить звук" : "Убрать звук"
        
        let muteAction = UIContextualAction(style: .normal, title: muteActionTitle, handler: { _,_,complete in
            self.muteChat(chat.id)
            complete(true)
        })
        
        muteAction.image = UIImage(systemName: chat.isMuted ? "speaker.wave.3" : "speaker.slash" )
        muteAction.backgroundColor = .systemIndigo
        return UISwipeActionsConfiguration(actions: [deleteAction, muteAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt
                                indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard !tableView.isEditing else { return nil }
        
        let chat = dataManager.getChatsForFolder(folderName)[indexPath.row]
        
        let readActionTitle = chat.isLastMessageRead ? "Отметить непроч." : "Прочитать"
        
        let readAction = UIContextualAction(style: .normal, title: readActionTitle, handler: { _,_,complete in
            complete(true)
        })
        readAction.backgroundColor = .systemBlue
        readAction.image = UIImage(systemName: chat.isLastMessageRead ? "eye.slash" : "eye")
        
        let pinAction = UIContextualAction(style: .normal, title: "Закрепить", handler: { _,_,complete in
            complete(true)
        })
        pinAction.backgroundColor = .systemGreen
        pinAction.image = UIImage(systemName: chat.isPinned ? "pin.slash" : "pin")
        return UISwipeActionsConfiguration(actions: [pinAction, readAction])
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard !tableView.isEditing else { return nil }
        return self.contextMenuConfiguration(tableView, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard !tableView.isEditing else { return }
        
        animator.addCompletion {
            guard let identifier = configuration.identifier as? String,
                  let index = Int(identifier) else {
                  return
            }
            let chatVC = ChatViewController()
            
            var chatName: String?
            
            let chat = self.dataManager.getChatsForFolder(self.folderName)[index]
            
            switch chat.type {
            case .groupChat(let name, _, _): chatName = name
            case .privateChat(let user): chatName = user.userName
            }
            
            guard let name = chatName else {
                return
            }
            
            chatVC.title = name
            chatVC.chatInfo = chat
            chatVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    private func contextMenuConfiguration(_ tableView: UITableView, indexPath: IndexPath) -> UIContextMenuConfiguration? {
        guard !tableView.isEditing else { return nil }
        
        let identifier = "\(indexPath.row)" as NSString
        let chatVC = ChatViewController()
        
        var chatName: String?
        
        let chat = dataManager.getChatsForFolder(folderName)[indexPath.row]
        
        switch chat.type {
        case .groupChat(let name, _, _): chatName = name
        case .privateChat(let user): chatName = user.userName
        }
        
        guard let name = chatName else {
            return nil
        }
        
        chatVC.title = name
        chatVC.chatInfo = chat
        return UIContextMenuConfiguration(
            identifier: identifier, previewProvider: { chatVC }) { _ in
            
            let muteActionTitle = chat.isMuted ? "Включить звук" : "Выключить звук"
            let muteActionImageName = chat.isMuted ? "volume.2" : "volume.slash"
            
            let muteAction = UIAction(
                title: muteActionTitle,
                image: UIImage(systemName: muteActionImageName)) { _ in
                self.muteChat(chat.id)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
                
            let readAction = UIAction(
                title: "Отметить прочитанным",
                image: UIImage(systemName: "checkmark")) { _ in
            }
            
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive) { _ in
                self.presentAlert {
                    self.deleteChat(chat.id)
                    self.tableView.deleteRows(at: [indexPath], with: .middle)
                } completionForCancel: {
                }
            }
            
            return UIMenu(title: "", image: nil, children: [muteAction, readAction, deleteAction])
        }
    }
    
    private func deleteChat(_ id: String) {
        dataManager.removeChatWithID(id)
        if let children = self.parent?.children {
            for child in children {
                if let vc = child as? ChatsTableViewController {
                    if vc != self {
                        vc.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func muteChat(_ id: String) {
        dataManager.muteChatWithID(id)
        if let children = self.parent?.children {
            for child in children {
                if let vc = child as? ChatsTableViewController {
                    if vc != self {
                        vc.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func beginEditingMode() {
        tableView.setEditing(true, animated: true)
    }
    
    func endEditingMode() {
        selectedChatsWhileEditing = []
        tableView.setEditing(false, animated: true)
    }

    func readSelectedChats() {
        selectedChatsWhileEditing.forEach { (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: false)
        }
        selectedChatsWhileEditing = []
    }
    
    func deleteSelectedChats() {
        selectedChatsWhileEditing = selectedChatsWhileEditing.sorted(by: { (first, second) -> Bool in
            return first.row > second.row
        })
        
        for indexPath in selectedChatsWhileEditing {
            
            
            let id = (tableView.cellForRow(at: indexPath) as! ChatTableViewCell).chatID
            
            deleteChat(id)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        selectedChatsWhileEditing = []
    }
    
    func presentAlert(_ completionForDelete: @escaping () -> Void, completionForCancel: (() -> Void)?) {
        let alertController = UIAlertController(title: nil, message: "Вы действительно хотите удалить историю сообщений?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            completionForDelete()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            if let completion = completionForCancel {
                completion()
            }
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
