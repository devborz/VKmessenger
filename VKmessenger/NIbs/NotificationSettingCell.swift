//
//  NotificationSettingCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 04.10.2020.
//

import UIKit

class NotificationSettingCell: UITableViewCell {

    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var settingNameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        settingImageView.image = nil
        settingNameLabel.text = nil
        valueLabel.text = nil
    }
    
    func setup(_ setting: NotificationSetting) {
        settingImageView.image = setting.image
        settingNameLabel.text = setting.name
        valueLabel.text = setting.value
        self.tintColor = setting.tintColor
        print(setting.tintColor.description)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
