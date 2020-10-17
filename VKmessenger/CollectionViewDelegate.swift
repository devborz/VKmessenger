//
//  CollectionViewDelegate.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 09.10.2020.
//

import UIKit

extension ChatsMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = foldersView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
        cell.setup(folders[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: .zero)
        label.text = folders[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 20, height: 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedChatFolderName = folders[indexPath.item]
        let chatIDs = chatsOfFolderIDs(name: selectedChatFolderName)
        visibleChats = chats.filter {
            chatIDs.contains($0[0])
        }
        chatsTableView.reloadData()
    }
}
