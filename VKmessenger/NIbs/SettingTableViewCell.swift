//
//  SettingTableViewCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 04.10.2020.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var settingNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        settingImageView = nil
        settingNameLabel = nil
    }
    
    func setup(_ setting: Setting) {
        settingNameLabel.text = setting.name
        settingImageView.image = setting.image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
