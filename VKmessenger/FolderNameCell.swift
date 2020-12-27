//
//  FolderCollectionViewCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 09.11.2020.
//

import UIKit

class FolderNameCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var indicatorLine: UIView!
    
    @IBOutlet weak var indicatorLineHeightConstraint: NSLayoutConstraint!
    
    override var isSelected: Bool {
        didSet {
            if isSelected != oldValue {
                if isSelected {
                    nameLabel.textColor = UIColor(named: "TextColor")
                    indicatorLineHeightConstraint.constant = 4
                } else {
                    nameLabel.textColor = .lightGray
                    indicatorLineHeightConstraint.constant = 0
                }
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
                    self.layoutIfNeeded()
                } completion: { completed in
                    
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        indicatorLine.layer.cornerRadius = 2
        indicatorLine.clipsToBounds = true
        indicatorLine.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
