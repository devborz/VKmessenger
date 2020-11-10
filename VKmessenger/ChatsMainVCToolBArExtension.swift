//
//  ChatsMainVCToolBArExtension.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 09.11.2020.
//

import UIKit

// MARK - Toolbar

extension ChatsMainViewController {
    func beginEditingMode() {
        chatsTableView.setEditing(true, animated: true)
        foldersCollectionView.isUserInteractionEnabled = false
        toolBar.alpha = 0
        tabBarController?.tabBar.addSubview(toolBar)
        UIView.animate(withDuration: 0.3) {
            self.toolBar.alpha = 1
        }
    }
    
    func endEditingMode() {
        selectedChatsWhileEditing = []
        chatsTableView.setEditing(false, animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.toolBar.alpha = 0
        }) { (completed) in
            if completed {
                self.toolBar.removeFromSuperview()
                self.foldersCollectionView.isUserInteractionEnabled = true
            }
        }
    }

    @objc func didTapEditButton() {
        if editBarButton.title == "Готово" {
            endEditingMode()
            editBarButton.title = "Изм."
        } else {
            beginEditingMode()
            editBarButton.title = "Готово"
        }
    }

    func setupToolBar() {
        if var frame = tabBarController?.tabBar.frame {
            frame.origin = CGPoint(x: 0, y: 0)
            frame.size.height = 50
            toolBar.frame = frame
        }
        
        let readButton = UIBarButtonItem(title: "Прочит. все", style: .plain, target: self, action: #selector(didTapReadButton))
        let deleteButton = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(didTapDeleteButton))
        deleteButton.tintColor = .red
    
        items.append(readButton)
        items.append(UIBarButtonItem(systemItem: .flexibleSpace))
        items.append(deleteButton)
        
        items[2].isEnabled = false
        toolBar.items = items
        
        editBarButton.action = #selector(didTapEditButton)
        editBarButton.target = self
    }
    
    @objc private func didTapReadButton() {
        readSelectedChats()
    }
    
    @objc private func didTapDeleteButton() {
        deleteSelectedChats()
    }
    
    func readSelectedChats() {
        selectedChatsWhileEditing.forEach { (indexPath) in
            chatsTableView.deselectRow(at: indexPath, animated: false)
        }
        selectedChatsWhileEditing = []
    }
    
    func deleteSelectedChats() {
        selectedChatsWhileEditing = selectedChatsWhileEditing.sorted(by: { (first, second) -> Bool in
            return first.row > second.row
        })
        
        for chatIndexPath in selectedChatsWhileEditing {
            deleteChat(chatIndexPath)
        }
        
        chatsTableView.deleteRows(at: selectedChatsWhileEditing, with: .automatic)
        
        selectedChatsWhileEditing = []
    }
}

