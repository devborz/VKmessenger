//
//  IncomingMessageTableViewCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 17.10.2020.
//

import UIKit

class IncomingMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textContentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var indicatorImageView: UIImageView!
    
    @IBOutlet weak var bubbleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bubbleView.layer.cornerCurve = .circular
        bubbleView.layer.cornerRadius = 10
        textContentLabel.text = "This text will not fit into one line and should break"
        textContentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        textContentLabel.sizeToFit()
        textContentLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textContentLabel.text = nil
        timeLabel.text = nil
        indicatorImageView.image = nil
    }
    
    func setup(_ message: Message) {
        switch message.kind {
        case .text(let text): textContentLabel.text = text
        default: print("image")
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        timeLabel.text = formatter.string(from: message.sentDate)
        timeLabel.textColor = UIColor.systemGray
        
        avatarImageView.image = message.sender.avatar
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.selectionStyle = .default
        } else {
            self.selectionStyle = .none
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
