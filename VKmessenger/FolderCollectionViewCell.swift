//
//  FolderCollectionViewCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 09.11.2020.
//

import UIKit

class FolderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var selectionIndicatorView: UIView!
    
    var heightConstraint: NSLayoutConstraint?
    
    override var isSelected: Bool {
        willSet {
            if newValue != isSelected {
                if newValue {
                    select(true)
                } else {
                    deselect(true)
                }
            }
        }
    }
    
    func select(_ animated: Bool) {
        heightConstraint?.constant = 5
        nameLabel.textColor = .white
        if animated {
            UIView.animate(withDuration: 0.2) { [self] in
                self.layoutIfNeeded()
            }
        }
    }
    
    func deselect(_ animated: Bool) {
        nameLabel.textColor = .lightGray
        heightConstraint?.constant = 0
        if animated {
            UIView.animate(withDuration: 0.2) { [self] in
                self.layoutIfNeeded()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        heightConstraint = selectionIndicatorView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
        selectionIndicatorView.clipsToBounds = true
        selectionIndicatorView.layer.cornerRadius = 3
        selectionIndicatorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
//    override func prepareForReuse() {
//        heightConstraint?.constant = 0
//        isSelected = false
//        setNeedsLayout()
//    }
    

}
