//
//  IncomingMessageTableViewCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 17.10.2020.
//

import UIKit

class IncomingMessageTableViewCell: MessageTableViewCell {
    
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
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: message.sentDate)
        let minute = calendar.component(.minute, from: message.sentDate)
        
        let hourString = String(hour).count > 1 ? String(hour) : "0" + String(hour)
        let minuteString = String(minute).count > 1 ? String(minute) : "0" + String(minute)
        
        timeLabel.text = "\(hourString):\(minuteString)"
        timeLabel.textColor = UIColor.systemGray
        
//        let interaction = UIContextMenuInteraction(delegate: self)
//        bubbleView.addInteraction(interaction)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
