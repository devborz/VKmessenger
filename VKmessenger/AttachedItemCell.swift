//
//  AttachedItemCell.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 25.11.2020.
//

import UIKit

class AttachedItemCell: UICollectionViewCell {
    
    var dataSource: AttachedItemCellDataSource?
    
    var delegate: AttachedItemCellDelegate?
    
    override class func awakeFromNib() {
        
    }
    
    override func prepareForReuse() {
    }
    
    func setup(_ attachedItem: AttachedItem) {
        switch attachedItem  {
        case .Image(let image): setupImageItem(image)
        case .Video(let media): setupVideoItem(media)
        case .Music: setupMusicItem()
        case .Document: setupDocumentItem()
        case .Locaion: setupLocationItem()
        }
        setupDeleteButton()
    }
    
    func setupImageItem(_ image: UIImage) {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
    }
    
    func setupVideoItem(_ media: Media) {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        imageView.image = media.thumbnail
        imageView.contentMode = .scaleAspectFill
        
        let time: Int = Int(media.duration.seconds)
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        var durationStamp = ""
        if hours > 0 {
            durationStamp = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        } else {
            durationStamp = String(format:"%02i:%02i", minutes, seconds)
        }
        
        let durationLabel = UILabel()
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(durationLabel)
        durationLabel.text = durationStamp
        
        durationLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -5).isActive = true
        durationLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -5).isActive = true
        durationLabel.widthAnchor.constraint(equalToConstant: NSAttributedString(string: durationStamp, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11, weight: .semibold)]).size().width + 8).isActive = true
        
        durationLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        durationLabel.textAlignment = .center
        durationLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
        durationLabel.layer.cornerRadius = 5
        durationLabel.clipsToBounds = true
    }
    
    func setupMusicItem() {
        
    }
    
    func setupDocumentItem() {
        
    }
    
    func setupLocationItem() {
        
    }
    
    func setupDeleteButton() {
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.imageView?.contentMode = .center
        deleteButton.imageView?.backgroundColor = .white
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.tintColor = .systemGray
        
        self.addSubview(deleteButton)
        
        deleteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        deleteButton.imageView?.layer.cornerRadius = (deleteButton.imageView?.frame.width)! / 2
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: -2).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 2).isActive = true
        
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    }
    
    @objc func didTapDeleteButton() {
        guard let dataSource = dataSource, let indexPath = dataSource.indexPath(forCell: self) else {
            return
        }
        delegate?.didTapDeleteItem(withIndexPath: indexPath)
    }
}

protocol AttachedItemCellDelegate {
    func didTapDeleteItem(withIndexPath indexPath: IndexPath)
}

protocol AttachedItemCellDataSource {
    func indexPath(forCell cell: AttachedItemCell) -> IndexPath?
}
