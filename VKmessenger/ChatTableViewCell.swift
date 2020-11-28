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
    
    func setup(_ chat: Chat) {
        var chatName: String?
        var chatImage: UIImage?

        switch chat.type {
        case .groupChat(let name, _, let image): chatName = name; chatImage = image
        case .privateChat(let user): chatName = user.userName; chatImage = user.avatar
        }
        
        guard let name = chatName, let image = chatImage else {
            return
        }
        
        chatNameLabel.text = name
        
        if let message = chat.lastMessage {
            switch message.kind {
            case .text(let text): lastMessageLabel.text = text
            case .image(_): print("image")
            case .voice: print("voice")
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            timeLabel.text = formatter.string(from: message.sentDate)
            timeLabel.textColor = UIColor.systemGray
        }
        
        chatImageView.backgroundColor = .white
        chatImageView.image = image
        
        chatImageView.clipsToBounds = true
        chatImageView.layer.cornerRadius = chatImageView.frame.width / 2
        
        if (!chat.isMuted) {
            muteImageView.image = nil
        } else {
            muteImageView.image = UIImage(systemName: "speaker.slash.fill")
            muteImageView.tintColor = .systemGray
        }
    }
}
