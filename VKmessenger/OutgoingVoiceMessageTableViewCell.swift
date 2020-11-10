//
//  OutgoingVoiceMessageTableViewCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 05.11.2020.
//

import UIKit

class OutgoingVoiceMessageTableViewCell: UITableViewCell {
    
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.selectionStyle = .default
        } else {
            self.selectionStyle = .none
        }
    }
    
    func setup(_ message: Message) {
    }
    
    
    @IBAction func didTapPlayButton(_ sender: Any) {
        if playButton.isSelected {
            playButton.isSelected = false
        } else {
            playButton.isSelected = true
        }
    }
    
    @IBAction func didChangeValue(_ sender: UISlider) {
    }
    
}
