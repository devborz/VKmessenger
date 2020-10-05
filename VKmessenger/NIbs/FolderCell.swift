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
    }
}
