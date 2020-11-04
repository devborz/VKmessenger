//
//  MessagesTableView.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 31.10.2020.
//

import UIKit

extension UITableView {
    func scrollToLast(_ animated: Bool) {
        guard numberOfSections > 0 else {
            return
        }

        let lastSection = numberOfSections - 1

        guard numberOfRows(inSection: lastSection) > 0 else {
            return
        }

        let lastRowIndexPath = IndexPath(row: numberOfRows(inSection: lastSection) - 1,
                                          section: lastSection)
        scrollToRow(at: lastRowIndexPath, at: .bottom, animated: animated)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == messagesTableView {
            return messages.count
        } else {
            return chatMenuOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == messagesTableView {
            if messages[indexPath.row].sender.senderId == chatInfo!.currentUser.senderId {
                let cell = messagesTableView.dequeueReusableCell(withIdentifier: "OutgoingMessageCell", for: indexPath) as! OutgoingMessageTableViewCell
                cell.setup(messages[indexPath.row])
                return cell
            } else {
                let cell = messagesTableView.dequeueReusableCell(withIdentifier: "IncomingMessageCell", for: indexPath) as! IncomingMessageTableViewCell
                cell.setup(messages[indexPath.row])
                return cell
            }
        } else {
            let cell = dropdownMenuTableView.dequeueReusableCell(withIdentifier: "ChatMenuCell", for: indexPath) as! ChatMenuCell
            cell.cellNameLabel.text = chatMenuOptions[indexPath.row].name
            cell.cellImageView.image = chatMenuOptions[indexPath.row].image
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == messagesTableView {
            messagesTableView.deselectRow(at: indexPath, animated: false)
        } else {
            dropdownMenuTableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return self.contextMenuConfiguration(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            if let viewController = animator.previewViewController {
                self.show(viewController, sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return contextMenuTargetPreview(configuration)
    }
    
    func tableView(_ tableView: UITableView,
        previewForHighlightingContextMenuWithConfiguration
        configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return contextMenuTargetPreview(configuration)
    }
    
    private func contextMenuConfiguration(_ indexPath: IndexPath) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.row)" as NSString
        
        return UIContextMenuConfiguration(
            identifier: identifier, previewProvider: nil) { _ in

            let answerAction = UIAction(
                title: "Ответить",
                image: UIImage(systemName: "arrowshape.turn.up.backward")) { _ in
            }
            
            let copyAction = UIAction(
                title: "Скопировать",
                image: UIImage(systemName: "square.on.square")) { _ in
            }
            
            let shareAction = UIAction(
                title: "Переслать",
                image: UIImage(systemName: "arrowshape.turn.up.forward")) { _ in
            }
            
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive) { _ in
                self.messages.remove(at: indexPath.row)
                self.messagesTableView.deleteRows(at: [indexPath], with: .fade)
                self.indexPathOfDeletedMessage = indexPath
            }
            
            return UIMenu(title: "", image: nil, children: [answerAction, copyAction, shareAction, deleteAction])
        }
    }
    
    private func contextMenuTargetPreview(_ configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let identifier = configuration.identifier as? String,
              let index = Int(identifier) else {
              return nil
        }
         
        guard indexPathOfDeletedMessage == nil else {
            indexPathOfDeletedMessage = nil
            return nil
        }
        
        var bubbleView: UIView?
        
        if messages[index].sender.senderId == chatInfo!.currentUser.senderId {
          let cell = messagesTableView.cellForRow(at: IndexPath(row: index, section: 0))
              as? OutgoingMessageTableViewCell
          bubbleView = cell?.bubbleView
        } else {
          let cell = messagesTableView.cellForRow(at: IndexPath(row: index, section: 0))
              as? IncomingMessageTableViewCell
          bubbleView = cell?.bubbleView
        }

        return UITargetedPreview(view: bubbleView!)
    }
}


