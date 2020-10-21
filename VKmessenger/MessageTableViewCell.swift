//
//  MessageTableViewCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 19.10.2020.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    func returnContextMenuConfiguration(_ index: Int) -> UIContextMenuConfiguration {
        
        // 2
        let identifier = "\(index)" as NSString
        
        return UIContextMenuConfiguration(
          identifier: identifier,
          previewProvider: nil) { _ in
            // 3
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
              }
            
            // 5
            return UIMenu(title: "", image: nil, children: [answerAction, copyAction, shareAction, deleteAction])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
