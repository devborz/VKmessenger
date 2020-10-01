//
//  MessageTableViewCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 30.09.2020.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var lastMessageLabel: UILabel!
    var chatID: String?
    var chatImage: UIImage?
    var chatName: String?
    var lastMessage: String?
    var lastTime: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        chatID = nil
        chatImage = nil
        chatName = nil
        lastMessage = nil
        lastTime = nil
    }
    
    func setup(_ chatID: String, chatImage: UIImage, chatName: String, lastMessage: String, lastTime: String) {
        self.chatID = chatID
        self.chatImage = chatImage
        self.chatName = chatName
        self.lastMessage = lastMessage
        self.lastTime = lastTime
        self.chatNameLabel.text = self.chatName
        self.chatImageView.image = self.chatImage
        self.lastMessageLabel.text = self.lastMessage! + " " + self.lastTime!
    }
}
