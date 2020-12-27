//
//  ChatsVCCollectionViewDelegateExtension.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 07.12.2020.
//

import UIKit


class CollectionViewCell: UICollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}

class CollectionView: UICollectionView {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer.view is CollectionView else { return false }
        let touchPoint = gestureRecognizer.location(in: self)
        let x = Int(touchPoint.x) % Int(self.frame.width)
        if x > 60 && x < Int(self.frame.size.width) - 60 {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        return false
    }
}

// MARK: Folders Collection View

extension ChatsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupChatsCollectionView() {
        foldersChatsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(foldersChatsCollectionView)
        
        foldersChatsCollectionView.topAnchor.constraint(equalTo: navBarSeparatorLineView.bottomAnchor).isActive = true
        foldersChatsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        foldersChatsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        foldersChatsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        foldersChatsCollectionView.delegate = self
        foldersChatsCollectionView.dataSource = self
        
        foldersChatsCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "ChatsCollectionCell")
        
        foldersChatsCollectionView.showsVerticalScrollIndicator = true
        foldersChatsCollectionView.showsHorizontalScrollIndicator = false
        foldersChatsCollectionView.isDirectionalLockEnabled = true
        foldersChatsCollectionView.backgroundColor = UIColor(named: "color")
        
        if let layout = foldersChatsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = foldersChatsCollectionView.bounds.size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        folderNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == foldersNamesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderNameCell
            cell.nameLabel.text = folderNames[indexPath.item]
            cell.nameLabel.sizeToFit()
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatsCollectionCell", for: indexPath) as! CollectionViewCell
            
            let chatsTableVC = ChatsTableViewController(style: .plain)
            chatsTableVC.folderName = folderNames[indexPath.item]
            addChild(chatsTableVC)
            chatsTableVC.view.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(chatsTableVC.view)
            
            chatsTableVC.view.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            chatsTableVC.view.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
            chatsTableVC.view.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            chatsTableVC.view.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            
            chatsTableVC.didMove(toParent: self)
            
            chatsTableVC.tableView.gestureRecognizers?.forEach { recognizer in
                let name = String(describing: type(of: recognizer))
                guard name == "_UISwipeActionPanGestureRecognizer" else { return }
                recognizer.require(toFail: collectionView.panGestureRecognizer)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == foldersNamesCollectionView {
//            if folderNames[indexPath.item] != folderName {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                foldersChatsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                folderName = folderNames[indexPath.item]
//            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == foldersNamesCollectionView ? 0 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == foldersNamesCollectionView {
            return CGSize(width: 50, height: 40)
        } else {
            return collectionView.frame.size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return contextMenuTargetPreview(configuration)
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return contextMenuTargetPreview(configuration)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.row)" as NSString
        
        return UIContextMenuConfiguration(
            identifier: identifier, previewProvider: nil) { _ in
            
            let setupFolderAction = UIAction(title: "Настроить папку", image: UIImage(systemName: "square.and.pencil")) { action in
                
            }
            
            let addChatsAction = UIAction(title: "Добавить чаты", image: UIImage(systemName: "plus")) { action in
                
            }
            
            let removeAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                
            }
            
            let changeOrderAction = UIAction(title: "Изменить порядок", image: UIImage(systemName: "folder.badge.gear")) { action in
                
            }
            
            let menu = UIMenu(title: "", image: nil, identifier: UIMenu.Identifier(rawValue: "menu"), options: .displayInline, children: [changeOrderAction])
            
            return UIMenu(title: "", image: nil, children: [setupFolderAction, addChatsAction, removeAction, menu])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        animator.addCompletion {
           
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == foldersChatsCollectionView {
            let index = scrollView.contentOffset.x / scrollView.frame.width
            let indexPath = IndexPath(item: Int(index), section: 0)
            foldersNamesCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            folderName = folderNames[indexPath.item]
        }
    }
    
    private func contextMenuTargetPreview(_ configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let identifier = configuration.identifier as? String else {
            return nil
        }
        
        guard let index = Int(identifier) else { return nil }
        
        guard let cell = foldersNamesCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FolderNameCell
        else { return nil }

        return UITargetedPreview(view: cell.containerView!)
    }
}
