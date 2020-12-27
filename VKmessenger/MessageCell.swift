//
//  MessageCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 30.11.2020.
//

import UIKit

class MessageCell: UITableViewCell {
    
    var message: Message?
    
    var delegate: MessageCellDelegate?

    let textContentLabel = UILabel()
    
    let timeLabel = UILabel()
    
    let avatarImageView = UIImageView()
    
    let indicatorImageView = UIImageView()
    
    let bubbleView = UIView()
    
    let gradientLayer = CAGradientLayer()
    
    var itemsCollectionView: UICollectionView?
    
    var collectionViewHeightConstraint: NSLayoutConstraint?
    
    var collectionViewWidthConstraint: NSLayoutConstraint?
    
    var messageToReply: AttachedItem!
    
    var attachedItems = [AttachedItem]()
    
    var contentHeight: CGFloat {
        var height: CGFloat = 0
        for item in attachedItems {
            let imageView = UIImageView()
            switch item {
            case .Image(image: let image):
                imageView.image = image
                height += imageView.contentClippingSize.height
            case .Video(media: let media):
                imageView.image = media.thumbnail
                height += imageView.contentClippingSize.height
            case .Document(document: _): height += 70
            case .Location(coordinate: _): height += 120
            case .Message(message: _): break
            }
            height += 5
        }
        return height
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        gradientLayer.removeFromSuperlayer()
        
        backgroundColor = .clear
        messageToReply = nil
        attachedItems = []
        delegate = nil
        message = nil
        itemsCollectionView = nil
        collectionViewWidthConstraint?.isActive = false
        collectionViewHeightConstraint?.isActive = false
        collectionViewHeightConstraint = nil
        collectionViewWidthConstraint = nil
    }
    
    func setup(_ message: Message) {
        self.message = message
        
        switch message.kind {
        case .standart(let text, let attachedItems, let messageToReply):
            textContentLabel.text = text
            if let items = attachedItems {
                self.attachedItems = items
            }
            if let message = messageToReply {
                self.messageToReply = message
            }
        case .voice(messageToReply: let messageToReply):
            break
        }
    
        setupAvatarImageView()
        setupBubbleView()
        setupTextLabel()
        setupMessageToReplyView()
        setupTimeStamp()
        setupCollectionView()
        setupIndicatorImageView()
        
//        if message.type == .outgoing {
//            let color1 = UIColor.systemBlue.withAlphaComponent(0.8).cgColor
//            let color2 = UIColor.systemBlue.withAlphaComponent(0.8).cgColor
//            gradientLayer.colors = [color1, color2]
//            bubbleView.layer.insertSublayer(gradientLayer, at: 0)
//            bubbleView.layer.masksToBounds = true
//            gradientLayer.frame = CGRect(x: 0, y: 0, width: 250, height: contentHeight)
//        }
    }
    
    func setupMessageToReplyView() {
        
    }
    
    func setupAvatarImageView() {
        if message!.type == .incoming {
            avatarImageView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(avatarImageView)
            
            avatarImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
            avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true
            avatarImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            avatarImageView.contentMode = .scaleAspectFill
            avatarImageView.clipsToBounds = true
            avatarImageView.layer.cornerRadius = 15 
            avatarImageView.image = message!.sender.avatar
        }
    }
    
    func setupBubbleView() {
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)
        
        switch message!.type {
        case .incoming:
            bubbleView.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 5).isActive = true
        case .outgoing:
            bubbleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        }
        
        bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 240).isActive = true
    
        bubbleView.layer.cornerCurve = .circular
        bubbleView.layer.cornerRadius = 10
    
        bubbleView.backgroundColor = message!.type == .incoming ? UIColor(named: "IncomingMessageColor") : UIColor(named: "OutgoingMessageColor")
    }
    
    func setupTextLabel() {
        textContentLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(textContentLabel)
        
        textContentLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5).isActive = true
        textContentLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 5).isActive = true
        textContentLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -5).isActive = true
        textContentLabel.numberOfLines = 0
        textContentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        textContentLabel.sizeToFit()
    }
    
    func setupTimeStamp() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(timeLabel)
        
        let topConstraint = timeLabel.topAnchor.constraint(equalTo: textContentLabel.bottomAnchor, constant: 0)
        topConstraint.priority = UILayoutPriority(rawValue: 500)
        topConstraint.isActive = true
        timeLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 5).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -5).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5).isActive = true
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        timeLabel.text = formatter.string(from: message!.sentDate)
        timeLabel.textColor = UIColor.systemGray
        timeLabel.textAlignment = .right
        timeLabel.font = .systemFont(ofSize: 12)
    }
    
    func setupCollectionView() {
        guard attachedItems.count > 0 else { return }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        
        itemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let itemsCollectionView = itemsCollectionView else { return }
        
        itemsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(itemsCollectionView)
        
        itemsCollectionView.topAnchor.constraint(equalTo: textContentLabel.bottomAnchor).isActive = true
        itemsCollectionView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 5).isActive = true
        itemsCollectionView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -5).isActive = true
        itemsCollectionView.bottomAnchor.constraint(equalTo: timeLabel.topAnchor).isActive = true
        collectionViewWidthConstraint = itemsCollectionView.widthAnchor.constraint(equalToConstant: 230)
        collectionViewWidthConstraint?.isActive = true
        
        itemsCollectionView.isScrollEnabled = false
        itemsCollectionView.register(AttachedItemInMessageCell.self, forCellWithReuseIdentifier: "item")
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        
        itemsCollectionView.backgroundColor = .clear
        
//        itemsCollectionView.reloadData()
        
        collectionViewHeightConstraint = itemsCollectionView.heightAnchor.constraint(equalToConstant: contentHeight)
        collectionViewHeightConstraint?.isActive = true
        itemsCollectionView.reloadData()
    }
    
    func setupIndicatorImageView() {
        if message!.type == .outgoing {
            indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(indicatorImageView)
            
            indicatorImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
            indicatorImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
            indicatorImageView.rightAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: -5).isActive = true
            indicatorImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -20).isActive = true
            
            if message!.state == .unread {
                indicatorImageView.image = UIImage(systemName: "circle.fill")
            } else {
                indicatorImageView.image = nil
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.selectionStyle = .default
        } else {
            self.selectionStyle = .none
        }
    }
}


extension MessageCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! AttachedItemInMessageCell
        cell.setup(attachedItems[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageView = UIImageView()
        switch attachedItems[indexPath.item] {
        case .Image(image: let image):
            imageView.image = image
            return CGSize(width: 230, height: imageView.contentClippingSize.height)
        case .Video(media: let media):
            imageView.image = media.thumbnail
            return CGSize(width: 230, height: imageView.contentClippingSize.height)
        case .Document(document: _): return CGSize(width: 230, height: 70)
        case .Location(coordinate: _): return CGSize(width: 230, height: 120)
        case .Message(message: _): return CGSize(width: 230, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let item = attachedItems[indexPath.item]
        switch item {
        case.Image:
            delegate?.didTapCell(with: item)
        case .Video:
            delegate?.didTapCell(with: item)
        default: break
        }
    }
}

extension UIImageView {
    var contentClippingSize: CGSize {
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width

            let ratio = 230/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        return CGSize(width: -1.0, height: -1.0)
    }
}

protocol MessageCellDelegate {
    func didTapCell(with item: AttachedItem)
}
