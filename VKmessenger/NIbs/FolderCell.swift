//
//  FolderCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 05.10.2020.
//

import UIKit

class FolderCell: UICollectionViewCell {
    
    @IBOutlet weak var nameView: UIView!

    @IBOutlet public weak var nameLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0) {
                    self.nameView.backgroundColor = UIColor.systemBlue.withAlphaComponent(1)
                }
            } else {
                UIView.animate(withDuration: 0) {
                    self.nameView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameView.layer.cornerRadius = 10
        self.nameView.clipsToBounds = true
        self.nameView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0)
        self.nameLabel.backgroundColor = .clear
        self.nameLabel.highlightedTextColor = UIColor.lightGray
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
    }
    
    func setup(_ name: String) {
        nameLabel.text = name
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    func selectWithProgress(_ progress: CGFloat) {
        nameView.backgroundColor = UIColor.systemBlue.withAlphaComponent(progress)
//        nameLabel.textColor = UIColor(named: "BackgroundColor")?.withAlphaComponent(progress)
    }
    
    func deselectWithProgress(_ progress: CGFloat) {
        nameView.backgroundColor = UIColor.systemBlue.withAlphaComponent(1 - progress)
//        nameLabel.textColor = UIColor.lightGray.withAlphaComponent(progress)
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
