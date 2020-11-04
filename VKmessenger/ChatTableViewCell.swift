//
//  ChatTableViewCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 30.09.2020.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chatNameLabel: UILabel!
    
    @IBOutlet weak var chatImageView: UIImageView!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var muteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chatImageView.layer.masksToBounds = false
        chatImageView.layer.cornerRadius = chatImageView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {

    }
    
    func setup(_ chatID: String, chatImage: UIImage, chatName: String, lastMessage: String, lastTime: String) {
        chatNameLabel.text = chatName
        lastMessageLabel.text = lastMessage
        chatImageView.backgroundColor = .white
        timeLabel.text = lastTime
        chatImageView.image = chatImage
        
        chatImageView.clipsToBounds = true
        chatImageView.layer.cornerRadius = chatImageView.frame.width / 2
    }
}
