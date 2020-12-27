//
//  ChatTitleView.swift
//  VKmessenger
//
//  Created by Усман Туркаев on 04.11.2020.
//

import UIKit

class ChatTitleView: UIView {
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                didSelectTitleView()
            } else {
                didDeselectTitleView()
            }
        }
    }
    
    var delegate: ChatTitleViewDelegate?
    
    var dataSource: ChatTitleViewDataSource? {
        didSet {
            if oldValue == nil {
                chatNameLabel.text = dataSource?.setName(self)
                chatImageView.image = dataSource?.setImage(self)
            }
        }
    }
    
    var chatImageView = UIImageView()
    
    var chatNameLabel = UILabel()
    
    var chatActivityLabel = UILabel()
    
    var accessoryImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        chatImageView.translatesAutoresizingMaskIntoConstraints = false
        chatNameLabel.translatesAutoresizingMaskIntoConstraints = false
        chatActivityLabel.translatesAutoresizingMaskIntoConstraints = false
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        setupAvatarView()
        
        setupNameLabel()
        
        setupActivityLabel()
        
        setupAccessoryImageView()
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTitleView))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupNameLabel() {
        self.addSubview(chatNameLabel)
        
        chatNameLabel.leftAnchor.constraint(equalTo: chatImageView.rightAnchor, constant: 5).isActive = true
        chatNameLabel.topAnchor.constraint(equalTo: self.topAnchor)
            .isActive = true
        chatNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        
        chatNameLabel.textColor = .label
        chatNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private func setupAvatarView() {
        self.addSubview(chatImageView)
        
        chatImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        chatImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        chatImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        chatImageView.heightAnchor.constraint(equalTo: chatImageView.widthAnchor).isActive = true
        
        chatImageView.clipsToBounds = true
        chatImageView.layer.cornerRadius = 17
        chatImageView.contentMode = .scaleAspectFill
    }
    
    
    private func setupActivityLabel() {
        self.addSubview(chatActivityLabel)
        
        chatActivityLabel.leftAnchor.constraint(equalTo: chatImageView.rightAnchor, constant: 5).isActive = true
        chatActivityLabel.topAnchor.constraint(equalTo: chatNameLabel.bottomAnchor).isActive = true
        chatActivityLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        chatActivityLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        chatActivityLabel.text = "Activity"
        chatActivityLabel.font = UIFont.systemFont(ofSize: 14)
        chatActivityLabel.textColor = .lightGray
    }
    
    private func setupAccessoryImageView() {
        self.addSubview(accessoryImageView)
        
        accessoryImageView.heightAnchor.constraint(equalToConstant: 17).isActive = true
        accessoryImageView.widthAnchor.constraint(equalToConstant: 17).isActive = true
        accessoryImageView.contentMode = .scaleAspectFit
        
        accessoryImageView.leftAnchor.constraint(equalTo: chatNameLabel.rightAnchor, constant: 3).isActive = true
        accessoryImageView.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: 0).isActive = true
        accessoryImageView.centerYAnchor.constraint(equalTo: chatNameLabel.centerYAnchor).isActive = true
    
        let config = UIImage.SymbolConfiguration(weight: .bold)
        accessoryImageView.image = UIImage(systemName: "chevron.down")?.withConfiguration(config)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.sizeToFit()
    }
    
    @objc private func didTapTitleView() {
        isSelected = !isSelected
    }
    
    private func rotateAccessoryImageView() {
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.accessoryImageView.transform = (self.accessoryImageView.transform.rotated(by: CGFloat(Double.pi)))
        } completion: { (completed) in
            if completed {
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc private func didSelectTitleView() {
        rotateAccessoryImageView()
        delegate?.didSelectTitleView(self)
    }
    
    @objc private func didDeselectTitleView() {
        rotateAccessoryImageView()
        delegate?.didDeselectTitleView(self)
    }
    
}

protocol ChatTitleViewDelegate {
    func didSelectTitleView(_ chatTitleView: ChatTitleView)
    
    func didDeselectTitleView(_ chatTitleView: ChatTitleView)
}

protocol ChatTitleViewDataSource {
    func setImage(_ chatTitleView: ChatTitleView) -> UIImage?
    
    func setName(_ chatTitleView: ChatTitleView) -> String?
}
