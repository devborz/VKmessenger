//
//  IncomingVoiceMessageTableViewCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 05.11.2020.
//

import UIKit

class IncomingVoiceMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var indicatorImagView: UIImageView!
    
    @IBOutlet weak var progressSliderView: UISlider!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var bubbleView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var progressTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerCurve = .circular
        bubbleView.layer.cornerRadius = 10
        
        let thumbImage = UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .regular))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        progressSliderView.setThumbImage(thumbImage, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(_ message: Message) {
        avatarImageView.image = message.sender.avatar
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        timeLabel.text = formatter.string(from: message.sentDate)
        timeLabel.textColor = UIColor.systemGray
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.selectionStyle = .default
        } else {
            self.selectionStyle = .none
        }
    }
    
    @IBAction func didTapPlayButton(_ sender: Any) {
        if playButton.isSelected {
            playButton.isSelected = false
        } else {
            playButton.isSelected = true
        }
    }
    
    @IBAction func didChangeValue(_ sender: Any) {
    }
    
    
}
