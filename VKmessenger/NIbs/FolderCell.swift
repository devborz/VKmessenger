//
//  FolderCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 05.10.2020.
//

import UIKit

class FolderCell: UICollectionViewCell {

    @IBOutlet public weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
    }
    
    func setup(_ name: String) {
        nameLabel.text = name
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
}

extension FolderCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let index = 0
        
        let identifier = "\(index)" as NSString
        
        return UIContextMenuConfiguration(
          identifier: identifier,
          previewProvider: nil) { _ in
            let configureFolderAction = UIAction(
              title: "Настроить папку",
              image: UIImage(systemName: "square.and.pencil")) { _ in
            }
            
            let addChatsAction = UIAction(
              title: "Добавить чаты",
              image: UIImage(systemName: "plus")) { _ in
            }
            
            let removeAction = UIAction(
              title: "Убрать",
              image: UIImage(systemName: "trash"),
              attributes: .destructive) { _ in
            }
        
            return UIMenu(title: "", image: nil, children: [configureFolderAction, addChatsAction, removeAction])
        }
    }
}
