//
//  ChatViewControllerTableViewDelegateExtension.swift
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let timeLabel = UILabel()
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 5).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        timeLabel.textAlignment = .center
        timeLabel.backgroundColor = .systemBackground
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        timeLabel.clipsToBounds = true
        timeLabel.layer.cornerRadius = 8
        timeLabel.textColor = .systemGray
    
        if messages[section].count > 0 {
        let dateFormatter = DateFormatter()
        
        let date = messages[section][0].sentDate
        dateFormatter.dateFormat = "dd/MM/yyyy"
        timeLabel.text = dateFormatter.string(from: date)
        
        
        timeLabel.widthAnchor.constraint(equalToConstant: (timeLabel.attributedText?.size().width)! + 16).isActive = true
        }
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.section][indexPath.row]
    
        switch message.kind {
        case .voice:
            switch message.type {
            case .incoming:
                let cell = messagesTableView.dequeueReusableCell(withIdentifier: "IncomingVoiceMessageCell", for: indexPath) as! IncomingVoiceMessageTableViewCell
                cell.setup(message)
                return cell
            case .outgoing:
                let cell = messagesTableView.dequeueReusableCell(withIdentifier: "OutgoingVoiceMessageCell", for: indexPath) as! OutgoingVoiceMessageTableViewCell
                cell.setup(message)
                return cell
            }
        case .standart:
            let cell = messagesTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
            cell.delegate = self
            cell.setup(message)
            cell.backgroundColor = .clear
            return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard !tableView.isEditing else { return nil }
        
        let replyAction = UIContextualAction(style: .normal, title: "Ответить", handler: { _,_,complete in
            let message = self.messages[indexPath.section][indexPath.row]
            self.messagesDelegate?.didSelectMessageToReply(message)
            complete(true)
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        })
        replyAction.image = UIImage(systemName: "arrowshape.turn.up.left")!.withTintColor(UIColor(named: "AccentColor")!).withRenderingMode(.alwaysOriginal)
        replyAction.backgroundColor = UIColor(named: "color")
    
        
        return UISwipeActionsConfiguration(actions: [replyAction])
    }
    
    private func contextMenuConfiguration(_ indexPath: IndexPath) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.section)-\(indexPath.row)" as NSString
        
        return UIContextMenuConfiguration(
            identifier: identifier, previewProvider: nil) { _ in

            let replyAction = UIAction(
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
                self.messages[indexPath.section].remove(at: indexPath.row)
                self.messagesTableView.deleteRows(at: [indexPath], with: .left)
                if self.messages[indexPath.section].count == 0 {
                    self.messages.remove(at: indexPath.section)
                    self.messagesTableView.deleteSections([indexPath.section], with: .left)
                }
                self.indexPathOfDeletedMessage = indexPath
            }
            let moreAction = UIAction(
                title: "Еще",
                image: UIImage(systemName: "ellipsis")) { _ in
                self.startEditingMode()
            }
            let moreMenu = UIMenu(title: "", image: nil, identifier: UIMenu.Identifier(rawValue: "more"), options: .displayInline, children: [moreAction])
            
            return UIMenu(title: "", image: nil, children: [replyAction, copyAction, shareAction, deleteAction, moreMenu])
        }
    }
    
    private func contextMenuTargetPreview(_ configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let identifier = configuration.identifier as? String else {
            return nil
        }
        
        let indexes = identifier.components(separatedBy: "-")
         
        guard indexes.count == 2 else {
            return nil
        }
        
        guard let section = Int(indexes[0]), let row = Int(indexes[1]) else {
            return nil
        }
        
        guard indexPathOfDeletedMessage == nil else {
            indexPathOfDeletedMessage = nil
            return nil
        }
        
        var bubbleView: UIView?
        
        let message = messages[section][row]
        
        switch message.kind {
        case .voice:
            switch message.type {
            case .incoming:
                let cell = messagesTableView.cellForRow(at: IndexPath(row: row, section: section))
                    as! IncomingVoiceMessageTableViewCell
                bubbleView = cell.bubbleView
            case .outgoing:
                let cell = messagesTableView.cellForRow(at: IndexPath(row: row, section: section))
                    as! OutgoingVoiceMessageTableViewCell
                bubbleView = cell.bubbleView
            }
        case .standart:
            let cell = messagesTableView.cellForRow(at: IndexPath(row: row, section: section))
                as! MessageCell
            bubbleView = cell.bubbleView
        }

        return UITargetedPreview(view: bubbleView!)
    }
}

extension ChatViewController: MessageCellDelegate {
    func didTapCell(with item: AttachedItem) {
        switch item {
        case .Image(image: let image):
            let vc = ImageViewController()
            self.navigationItem.backButtonTitle = "Назад"
            vc.image = image
            vc.modalTransitionStyle = .crossDissolve
            navigationController?.pushViewController(vc, animated: true)
        case .Video(media: let media):
            let vc = PlayerViewController()
            vc.media = media
            navigationController?.pushViewController(vc, animated: true)
            
        default: break
        }
    }
}

protocol MessagesDelegate {
    func didSelectMessageToReply(_ message: Message)
    
    func didSelectItemToAttach(_ attachedItem: AttachedItem)
}
