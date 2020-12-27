//
//  ChatsMainVCToolBarExtension.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 09.11.2020.
//

import UIKit

// MARK: Toolbar

extension ChatsViewController {
    func beginEditingMode() {
        for child in children {
            if let vc = child as? ChatsTableViewController {
                if vc.folderName == folderName {
                    vc.beginEditingMode()
                }
            }
        }
        foldersChatsCollectionView.isScrollEnabled = false
        foldersNamesCollectionView.isUserInteractionEnabled = false
        toolBar.alpha = 0
        tabBarController?.tabBar.addSubview(toolBar)
        UIView.animate(withDuration: 0.3) {
            self.toolBar.alpha = 1
        }
    }
    
    func endEditingMode() {
        for child in children {
            if let vc = child as? ChatsTableViewController {
                if vc.folderName == folderName {
                    vc.endEditingMode()
                }
            }
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.toolBar.alpha = 0
        }) { (completed) in
            if completed {
                self.toolBar.removeFromSuperview()
                self.foldersChatsCollectionView.isScrollEnabled = true
                self.foldersNamesCollectionView.isUserInteractionEnabled = true
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
        presentAlert {
            self.deleteSelectedChats()
        } completionForCancel: { [self] in
            for child in children {
                if let vc = child as? ChatsTableViewController {
                    if vc.folderName == folderName {
                        vc.endEditingMode()
                    }
                    
                    for chat in vc.selectedChatsWhileEditing {
                        vc.tableView.deselectRow(at: chat, animated: true)
                    }
                    vc.selectedChatsWhileEditing = []
                }
            }
        }

    }
    
    func readSelectedChats() {
        for child in children {
            if let vc = child as? ChatsTableViewController {
                if vc.folderName == folderName {
                    vc.readSelectedChats()
                }
            }
        }
    }
    
    func deleteSelectedChats() {
        for child in children {
            if let vc = child as? ChatsTableViewController {
                if vc.folderName == folderName {
                    vc.deleteSelectedChats()
                }
            }
        }
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

